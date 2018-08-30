require_relative 'agreement'


SUPPLY_TEACHER_FRAMEWORK_ID = "ST"
SUPPLY_TEACHER_MANAGED_SERVICE_LOT_ID = "#{SUPPLY_TEACHER_FRAMEWORK_ID}.MS"
SUPPLY_TEACHER_AGENCY_LOT_ID = "#{SUPPLY_TEACHER_FRAMEWORK_ID}.AG"

domain(:SupplyTeacherOfferings) {
  datatype(:FM_Offering, extends: Agreements::Offering,
           description: " An offer for FM elements ") {
    attribute :sc_cleared, String
  }
}

Agreements.new(:ST_Agreements) {
  agreement {
    kind :Framework
    id SUPPLY_TEACHER_FRAMEWORK_ID
    fwk_number "RM1234" #TODO proper fwk number for Supply teachers
    version "0.1.0"
    description "This agreement is for the provision of Supply Teachers"
    start_date date(2018, 10, 01) #TODO proper start date for Supply teachers
  }

  item_coding = lambda do
    scheme_id = :CCS; code = "CCS-#{SUPPLY_TEACHER_FRAMEWORK_ID}-#{id}"; unit = :Currency;
  end

  # Items common to both Lots
  items = [
      itemtype {
        description "Qualified Teacher: Non-SEN Roles"
        id :QT_NonSEN
        self.instance_exec &item_coding
        keyword "teacher"
        keyword "non-sen"
      },
      itemtype {
        description "Qualified Teacher: SEN Roles"
        id :QT_SEN
        self.instance_exec &item_coding
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
        description "Other Roles: Headteacher and Senior Leadership positions"
        id :Snr_SEN
        self.instance_exec &item_coding
      },
      itemtype {
        description "Other Roles: (Admin & Clerical Staff, IT Staff, Finance Staff, Cleaners etc.)"
        id :Src_SEN
        self.instance_exec &item_coding
      },
      itemtype {
        description "Nominated Workers"
        id :Nom_SEN
        self.instance_exec &item_coding
      },
      itemtype {
        description "Fixed Term Role (on School Payroll)"
        id :FTA_SEN
        self.instance_exec &item_coding
      },
  ]

  agreement {
    kind :Lot
    id SUPPLY_TEACHER_AGENCY_LOT_ID
    name "Hire supply teacher roles from an agency"
    part_of_id SUPPLY_TEACHER_FRAMEWORK_ID
    version "0.1.0"
    for item in items
      item_type item
    end

  }

  agreement {
    kind :Lot
    id SUPPLY_TEACHER_MANAGED_SERVICE_LOT_ID
    name "Hire an agency to sort out all your supply teacher needs"
    part_of_id SUPPLY_TEACHER_FRAMEWORK_ID
    version "0.1.0"
    for item in items
      item_type item
    end
  }
}

