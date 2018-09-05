require_relative 'agreement'
require 'csv'

SUPPLY_TEACHER_FRAMEWORK_ID = "ST"
SUPPLY_TEACHER_MANAGED_SERVICE_LOT_ID = "#{SUPPLY_TEACHER_FRAMEWORK_ID}.MS"
SUPPLY_TEACHER_AGENCY_LOT_ID = "#{SUPPLY_TEACHER_FRAMEWORK_ID}.AG"


Agreements.new(:Supply_Teacher_Agreements) {
  agreement {
    kind :Framework
    name "Supply Teachers framework"
    id SUPPLY_TEACHER_FRAMEWORK_ID
    fwk_number "RM1234" #TODO proper fwk number for Supply teachers
    version "0.1.0"
    description "This agreement is for the provision of Supply Teachers"
    start_date date(2018, 10, 01) #TODO proper start date for Supply teachers
  }

  item_coding = lambda do
    scheme_id :CPV; code "79610000/#{id}"; unit :Commission;
  end

  # Items common to both Lots
  Common_ST_items = [
      itemtype {
        description "Qualified Teacher: Non-SEN Roles"
        id :QT_NonSEN
        include &item_coding
        keyword "teacher"
        keyword "non-sen"
      },
      itemtype {
        description "Qualified Teacher: SEN Roles"
        id :QT_SEN
        include &item_coding
        keyword "teacher"
        keyword "sen teacher"
        keyword "Special Education Needs"
        keyword "Special Needs"
      },
      itemtype {
        description "Unqualified Teacher: Non-SEN Roles"
        id :NQT_NonSEN
        self.instance_exec &item_coding
        keyword "teacher"
        keyword "non-sen"
      },
      itemtype {
        description "Unqualified Teacher: SEN Roles"
        id :NQT_SEN
        self.instance_exec &item_coding
        keyword "teaching assistant"
        keyword "Special Education Needs"
        keyword "Special Needs"
      },
      itemtype {
        description "Educational Support Staff: Non-SEN roles (incl. Cover Supervisor and Teaching Assistant)"
        id :EdSup_NonSEN
        self.instance_exec &item_coding
      },
      itemtype {
        description "Educational Support Staff: SEN roles (incl. Cover Supervisor and Teaching Assistant)"
        id :EdSup_SEN
        self.instance_exec &item_coding
      },
      itemtype {
        description "Senior Roles"
        description "Other Roles: Headteacher and Senior Leadership positions"
        id :Senior
        self.instance_exec &item_coding
      },
      itemtype {
        description "Other Roles: (Admin & Clerical Staff, IT Staff, Finance Staff, Cleaners etc.)"
        id :Admin
        self.instance_exec &item_coding
      },
      itemtype {
        description "Nominated Workers"
        id :Nom
        self.instance_exec &item_coding
      },
      itemtype {
        description "Fixed Term Role (on School Payroll)"
        id :FTA
        self.instance_exec &item_coding
      },
  ]

  agreement {
    kind :Lot
    id SUPPLY_TEACHER_AGENCY_LOT_ID
    name "Supply Teachers from Agency"
    part_of_id SUPPLY_TEACHER_FRAMEWORK_ID
    offerType "SupplyTeacherOfferings::ST_Offering"
    version "0.1.0"
    for item in Common_ST_items
      item_type item
    end

  }

  agreement {
    kind :Lot
    id SUPPLY_TEACHER_MANAGED_SERVICE_LOT_ID
    name "Supply Teachers Managed Service"
    part_of_id SUPPLY_TEACHER_FRAMEWORK_ID
    offerType "SupplyTeacherOfferings::ST_Offering"
    version "0.1.0"
    for item in Common_ST_items
      item_type item
    end
  }
}

domain(:SupplyTeacherOfferings) {

  datatype(:ST_Offering, extends: Agreements::Offering,
           description: " An offer for ST supply
The offerings look the same for both lots - since they both relate to the same items and data") {
    attribute :commission, String, "The percentage the supplier charges for the item"
    attribute :duration, Selection(:Up_to_1_week, :Between_1_and_12_weeks, :Over_12_weeks)
    attribute :branch_name, String, "branch name from which the offer is supplied"
    attribute :branch_contact_id, String, "links to contact at the address", links: Parties::Contact
    attribute :vendor_type, Selection("Master_Vendor", "Neutral_Vendor"), "for managed service offerings", links: Parties::Contact
  }
}

def colmap_managing_suppliers(row)
  {
      :Vendor_type => row[0],
      :Supplier => row[1],
      :Item_ID => row[2],
      :Job_Type => row[3],
      :Up_to_1_week => row[4],
      :Between_1_and_12_weeks => row[5],
      :Over_12_weeks => row[6],
      :Contact_information => row[7]
  }
end

# expects CSV of the form
# 0          ,1        ,2      ,3       , 4          , 5                    , 6           , 7
# Vendor type,Supplier ,Item ID,Job Type,Up_to_1_week,Between_1_and_12_weeks,Over_12_weeks,Contact information
# @param [Domain] parties - all the parties involved; method adds new suppliers if not present by namne
# @param [Object] filename - name of CSV file
def load_managing_suppliers filename, parties


  # Load the suppliers from the file
  lines = CSV.foreach(filename)
  lines.each do |row|
    col = colmap_managing_suppliers(row)

    if col[:Vendor_type] != "Vendor type" then
      name = col[:Supplier]
      unless parties.contents[:party].find {|p| p.name == [name]}
        parties.instance_exec do
          party {
            org_name name
            id name # TODO will actually have to match this to a real supplier id, such as in SF
          }
        end
      end
    end
  end

  def time_options(item_type, colmap)
    if (:Nom == item_type.id || :FTA == item_type.id)
      return [:Over_12_weeks]
    else
      return [:Up_to_1_week, :Between_1_and_12_weeks, :Over_12_weeks]
    end
  end


  SupplyTeacherOfferings.new :ST_ManagementOfferings do
    lines.each do |row|
      col = colmap_managing_suppliers(row)
      if row[0] != "Vendor type" then
        item_type = get_st_item (row[2])
        if (!item_type)
          puts "Warning can't match item '#{row[2]}"
          next
        end
        for row_dur in time_options(item_type, col)
          name = row[1]
          st_offering do
            name "#{name}-#{item_type.description}-#{row_dur}"
            agreement_id SUPPLY_TEACHER_MANAGED_SERVICE_LOT_ID
            supplier_id name # TODO will actually have to match this to a real supplier id, such as in SF
            commission col[row_dur]
            item do
              type_id item_type.id
              unit :Commission
              value col[row_dur]
            end
          end
        end
      end
    end
  end

  return SupplyTeacherOfferings::ST_ManagementOfferings
end

def col_for_supplier row
  {
      :Col_Supplier_Name => row[0],
      :Col_Branch_Name => row[1],
      :Col_Branch_Contact_name => row[2],
      :Col_Address_1 => row[3],
      :Col_Address_2 => row[4],
      :Col_Town => row[5],
      :Col_County => row[6],
      :Col_Post_Code => row[7],
      :Col_Branch_Contact_Name_Email_Address => row[8],
      :Col_Branch_Telephone_Number => row[9],
      :Col_Region => row[10],
      [:QT_NonSEN, :Up_to_1_week] => row[11],
      [:QT_NonSEN, :Between_1_and_12_weeks] => row[12],
      [:QT_NonSEN, :Over_12_weeks] => row[13],
      [:QT_SEN, :Up_to_1_week] => row[14],
      [:QT_SEN, :Between_1_and_12_weeks] => row[15],
      [:QT_SEN, :Over_12_weeks] => row[16],
      [:NQT_NonSEN, :Up_to_1_week] => row[17],
      [:NQT_NonSEN, :Between_1_and_12_weeks] => row[18],
      [:NQT_NonSEN, :Over_12_weeks] => row[19],
      [:NQT_SEN, :Up_to_1_week] => row[20],
      [:NQT_SEN, :Between_1_and_12_weeks] => row[21],
      [:NQT_SEN, :Over_12_weeks] => row[22],
      [:EdSup_NonSEN, :Up_to_1_week] => row[23],
      [:EdSup_NonSEN, :Between_1_and_12_weeks] => row[24],
      [:EdSup_NonSEN, :Over_12_weeks] => row[25],
      [:EdSup_SEN, :Up_to_1_week] => row[26],
      [:EdSup_SEN, :Between_1_and_12_weeks] => row[27],
      [:EdSup_SEN, :Over_12_weeks] => row[28],
      [:Senior, :Up_to_1_week] => row[29],
      [:Senior, :Between_1_and_12_weeks] => row[30],
      [:Senior, :Over_12_weeks] => row[31],
      [:Admin, :Up_to_1_week] => row[32],
      [:Admin, :Between_1_and_12_weeks] => row[33],
      [:Admin, :Over_12_weeks] => row[34],
      [:Nom, :Nominated_workers] => row[35],
      [:FTA, :Fixed_Term_Contract] => row[36]
  }
end

# expects CSV of the form
# 0 Supplier Name,1 Branch Name/No.,2 Branch Contact name,3 Address 1,4 Address 2,5 Town,6 County,7 Post Code,8 Branch Contact Name Email Address,9 Branch Telephone Number,10 Region,11 QT_NonSEN/Up to 1 week,12 QT_NonSEN/Between 1 and 12 weeks,13 QT_NonSEN/Over 12 weeks,14 QT_SEN/Up to 1 week,15 QT_SEN/Between 1 and 12 weeks,16 QT_SEN/Over 12 weeks,17 NQT_NonSEN/Up to 1 week,18 NQT_NonSEN/Between 1 and 12 weeks,NQT_NonSEN/Over 12 weeks,NQT_SEN/Up to 1 week,NQT_SEN/Between 1 and 12 weeks,NQT_SEN/Over 12 weeks,EdSup_NonSEN/Up to 1 week,EdSup_NonSEN/Between 1 and 12 weeks,EdSup_NonSEN/Over 12 weeks,EdSup_SEN/Up to 1 week,EdSup_SEN/Between 1 and 12 weeks,EdSup_SEN/Over 12 weeks,Senior/Up to 1 week,Senior/Between 1 and 12 weeks,Senior/Over 12 weeks,Admin/Up to 1 week,Admin/Between 1 and 12 weeks,Over 12 weeks,Nom/Nominated workers,FTA/Fixed Term Contract (school payroll worker)
# @param [Domain] parties - all the parties involved; method adds new suppliers if not present by namne
# @param [Object] filename - name of CSV file
def load_recruitment_suppliers filename, parties

  SupplyTeacherOfferings.new :ST_RecruitmentOfferings do
    lines.each do |row|
      cols = col_for_supplier row
      if col[:Col_Supplier_Name] != "0 Supplier Name" then
        item_type = get_st_item (row[2])
        if (!item_type)
          puts "Warning can't match item '#{row[2]}"
          next
        end
        for type_time in type_times.keys
          supplier = col[:Col_Supplier_Name]
          st_offering do
            name "#{supplier}-#{item_type.description}-#{row_dur[1]}"
            agreement_id SUPPLY_TEACHER_MANAGED_SERVICE_LOT_ID
            supplier_id supplier # TODO will actually have to match this to a real supplier id, such as in SF
            commission col[type_time]
            item do
              type_id item_type.id
              unit :Commission
            end
          end
        end
      end
    end
  end

  return SupplyTeacherOfferings::ST_RecruitmentOfferings
end


def get_st_item item_id
  return Common_ST_items.find {|i| i.id.to_s == item_id}
end