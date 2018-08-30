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

Agreements.new( :ST_Agreements) {
  agreement {
    kind :Framework
    id SUPPLY_TEACHER_FRAMEWORK_ID
    fwk_number "RM1234" #TODO proper fwk number for Supply teachers
    version "0.1.0"
    description "This agreement is for the provision of Supply Teachers"
    start_date date(2018, 10, 01) #TODO proper start date for Supply teachers
  }

  agreement {
    kind :Lot
    id SUPPLY_TEACHER_AGENCY_LOT_ID
    name "Hire supply teacher roles from an agency"
    part_of_id SUPPLY_TEACHER_FRAMEWORK_ID
    version "0.1.0"
    item_type {
      desc = "Qualified Teacher: Non-SEN Roles"
      id :QT_NonSEN
      scheme_id :CCS
      description desc
      unit :Currency
      code "CCS-#{SUPPLY_TEACHER_AGENCY_LOT_ID}-#{self.id}"
      keyword "teacher"
      keyword "non-sen"
    }
    item_type {
      desc = "Qualified Teacher: SEN Roles"
      id :QT_SEN
      scheme_id :CCS; code "CCS-#{SUPPLY_TEACHER_AGENCY_LOT_ID}-#{self.id}"
      unit :Currency;
      keyword "teacher"
      keyword "sen teacher"
      keyword "Special Education Needs"
      keyword "Special Needs"
    }
  }

  agreement {
    kind :Lot
    id SUPPLY_TEACHER_MANAGED_SERVICE_LOT_ID
  }
#   Qualified Teacher: Non-SEN Roles
#   Qualified Teacher: SEN Roles
#   Unqualified Teacher: Non-SEN roles
#   Unqualified Teacher: SEN roles
#   "Educational Support Staff: Non-SEN roles
# (incl. Cover Supervisor and Teaching Assistant)"
#   "Educational Support Staff: SEN roles
# (incl. Cover Supervisor and Teaching Assistant)"
#   Other Roles: Headteacher and Senior Leadership positions
#   Other Roles: (Admin & Clerical Staff, IT Staff, Finance Staff, Cleaners etc.)
#   Nominated Workers
#   Fixed Term Role (on School Payroll)
}

