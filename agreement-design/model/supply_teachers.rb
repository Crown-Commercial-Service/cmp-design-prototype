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
    scheme_id :CPV; code "79610000/#{id}"; unit :Currency;
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

#expects CSV of the form
# 0          ,1        ,2      ,3       , 4          , 5                    , 6           , 7
# Vendor type,Supplier ,Item ID,Job Type,Up_to_1_week,Between_1_and_12_weeks,Over_12_weeks,Contact information
# @param [Domain] parties - all the parties involved; method adds new suppliers if not present by namne
# @param [Object] filename - name of CSV file
def load_managing_suppliers filename, parties

  # Load the suppliers from the file
  lines = CSV.foreach(filename)
  lines.each do |row|
    if row[0] != "Vendor type" then
      name = row[1]
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

  def time_options(item_type)
    if (:Nom == item_type.id || :FTA == item_type.id)
      return [[6, :Over_12_weeks]]
    else
      return [[4, :Up_to_1_week], [5, :Between_1_and_12_weeks], [6, :Over_12_weeks]]
    end
  end

  SupplyTeacherOfferings.new :ST_Offerings do
    lines.each do |row|
      if row[0] != "Vendor type" then
        item_type = get_st_item (row[2])
        if (!item_type)
          puts "Warning can't match item '#{row[2]}"
          next
        end
        for row_dur in time_options(item_type)
          name = row[1]
          st_offering do
            name "#{name}-#{item_type.description}-#{row_dur[1]}"
            agreement_id SUPPLY_TEACHER_MANAGED_SERVICE_LOT_ID
            supplier_id name # TODO will actually have to match this to a real supplier id, such as in SF
            commission row[row_dur[0]]
            item do
              type_id item_type.id
              unit :Currency
            end
          end
        end
      end
    end
  end

  return SupplyTeacherOfferings::ST_Offerings
end

def get_st_item desc
  return Common_ST_items.find {|i| i.id.to_s == desc}
end