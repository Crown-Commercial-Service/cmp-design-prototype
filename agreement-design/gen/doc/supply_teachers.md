# Model: Supply_Teacher_Agreements 
## agreement
### Agreement - Supply Teachers and Temporary Staff in Educational Establishments 
   - kind Framework
   - name Supply Teachers and Temporary Staff in Educational Establishments
   - long_name Supply Teachers and Temporary Staff in Educational Establishments
   - id RM3826
   - pillar People
   - status Live
   - category Workforce
   - version 0.1.0
   - description This agreement is for the provision of Supply Teachers
   - start_date 2018-08-30
   - original_end_date 2018-08-30
   - end_date 2018-08-30
### Agreement - Preferred Supplier List 
   - kind Lot
   - id RM3826.1
   - name Preferred Supplier List
   - long_name Preferred Supplier List
   - part_of_id RM3826
   - pillar People
   - category Workforce
   - offerType SupplyTeacherOfferings::ST_Offering
   - version 0.1.0
#### ItemType - itemtype 
     - description Qualified Teacher: Non-SEN Roles
     - id QT_NonSEN
     - scheme_id CPV
     - code 79610000/QT_NonSEN
     - unit Commission
     - keyword teacher
     - keyword non-sen
#### ItemType - itemtype 
     - description Qualified Teacher: SEN Roles
     - id QT_SEN
     - scheme_id CPV
     - code 79610000/QT_SEN
     - unit Commission
     - keyword teacher
     - keyword sen teacher
     - keyword Special Education Needs
     - keyword Special Needs
#### ItemType - itemtype 
     - description Unqualified Teacher: Non-SEN Roles
     - id NQT_NonSEN
     - scheme_id CPV
     - code 79610000/NQT_NonSEN
     - unit Commission
     - keyword teacher
     - keyword non-sen
#### ItemType - itemtype 
     - description Unqualified Teacher: SEN Roles
     - id NQT_SEN
     - scheme_id CPV
     - code 79610000/NQT_SEN
     - unit Commission
     - keyword teaching assistant
     - keyword Special Education Needs
     - keyword Special Needs
#### ItemType - itemtype 
     - description Educational Support Staff: Non-SEN roles (incl. Cover Supervisor and Teaching Assistant)
     - id EdSup_NonSEN
     - scheme_id CPV
     - code 79610000/EdSup_NonSEN
     - unit Commission
#### ItemType - itemtype 
     - description Educational Support Staff: SEN roles (incl. Cover Supervisor and Teaching Assistant)
     - id EdSup_SEN
     - scheme_id CPV
     - code 79610000/EdSup_SEN
     - unit Commission
#### ItemType - itemtype 
     - description Other Roles: Headteacher and Senior Leadership positions
     - id Senior
     - scheme_id CPV
     - code 79610000/Senior
     - unit Commission
#### ItemType - itemtype 
     - description Other Roles: (Admin & Clerical Staff, IT Staff, Finance Staff, Cleaners etc.)
     - id Admin
     - scheme_id CPV
     - code 79610000/Admin
     - unit Commission
#### ItemType - itemtype 
     - description Nominated Workers
     - id Nom
     - scheme_id CPV
     - code 79610000/Nom
     - unit Commission
#### ItemType - itemtype 
     - description Fixed Term Role (on School Payroll)
     - id FTA
     - scheme_id CPV
     - code 79610000/FTA
     - unit Commission
### Agreement - Master Vendor 
   - kind Lot
   - id RM3826.2
   - name Master Vendor
   - part_of_id RM3826
   - offerType SupplyTeacherOfferings::ST_Offering
   - version 0.1.0
#### ItemType - itemtype 
     - description Qualified Teacher: Non-SEN Roles
     - id QT_NonSEN
     - scheme_id CPV
     - code 79610000/QT_NonSEN
     - unit Commission
     - keyword teacher
     - keyword non-sen
#### ItemType - itemtype 
     - description Qualified Teacher: SEN Roles
     - id QT_SEN
     - scheme_id CPV
     - code 79610000/QT_SEN
     - unit Commission
     - keyword teacher
     - keyword sen teacher
     - keyword Special Education Needs
     - keyword Special Needs
#### ItemType - itemtype 
     - description Unqualified Teacher: Non-SEN Roles
     - id NQT_NonSEN
     - scheme_id CPV
     - code 79610000/NQT_NonSEN
     - unit Commission
     - keyword teacher
     - keyword non-sen
#### ItemType - itemtype 
     - description Unqualified Teacher: SEN Roles
     - id NQT_SEN
     - scheme_id CPV
     - code 79610000/NQT_SEN
     - unit Commission
     - keyword teaching assistant
     - keyword Special Education Needs
     - keyword Special Needs
#### ItemType - itemtype 
     - description Educational Support Staff: Non-SEN roles (incl. Cover Supervisor and Teaching Assistant)
     - id EdSup_NonSEN
     - scheme_id CPV
     - code 79610000/EdSup_NonSEN
     - unit Commission
#### ItemType - itemtype 
     - description Educational Support Staff: SEN roles (incl. Cover Supervisor and Teaching Assistant)
     - id EdSup_SEN
     - scheme_id CPV
     - code 79610000/EdSup_SEN
     - unit Commission
#### ItemType - itemtype 
     - description Other Roles: Headteacher and Senior Leadership positions
     - id Senior
     - scheme_id CPV
     - code 79610000/Senior
     - unit Commission
#### ItemType - itemtype 
     - description Other Roles: (Admin & Clerical Staff, IT Staff, Finance Staff, Cleaners etc.)
     - id Admin
     - scheme_id CPV
     - code 79610000/Admin
     - unit Commission
#### ItemType - itemtype 
     - description Nominated Workers
     - id Nom
     - scheme_id CPV
     - code 79610000/Nom
     - unit Commission
#### ItemType - itemtype 
     - description Fixed Term Role (on School Payroll)
     - id FTA
     - scheme_id CPV
     - code 79610000/FTA
     - unit Commission
## itemtype
### ItemType - itemtype 
   - description Qualified Teacher: Non-SEN Roles
   - id QT_NonSEN
   - scheme_id CPV
   - code 79610000/QT_NonSEN
   - unit Commission
   - keyword teacher
   - keyword non-sen
### ItemType - itemtype 
   - description Qualified Teacher: SEN Roles
   - id QT_SEN
   - scheme_id CPV
   - code 79610000/QT_SEN
   - unit Commission
   - keyword teacher
   - keyword sen teacher
   - keyword Special Education Needs
   - keyword Special Needs
### ItemType - itemtype 
   - description Unqualified Teacher: Non-SEN Roles
   - id NQT_NonSEN
   - scheme_id CPV
   - code 79610000/NQT_NonSEN
   - unit Commission
   - keyword teacher
   - keyword non-sen
### ItemType - itemtype 
   - description Unqualified Teacher: SEN Roles
   - id NQT_SEN
   - scheme_id CPV
   - code 79610000/NQT_SEN
   - unit Commission
   - keyword teaching assistant
   - keyword Special Education Needs
   - keyword Special Needs
### ItemType - itemtype 
   - description Educational Support Staff: Non-SEN roles (incl. Cover Supervisor and Teaching Assistant)
   - id EdSup_NonSEN
   - scheme_id CPV
   - code 79610000/EdSup_NonSEN
   - unit Commission
### ItemType - itemtype 
   - description Educational Support Staff: SEN roles (incl. Cover Supervisor and Teaching Assistant)
   - id EdSup_SEN
   - scheme_id CPV
   - code 79610000/EdSup_SEN
   - unit Commission
### ItemType - itemtype 
   - description Other Roles: Headteacher and Senior Leadership positions
   - id Senior
   - scheme_id CPV
   - code 79610000/Senior
   - unit Commission
### ItemType - itemtype 
   - description Other Roles: (Admin & Clerical Staff, IT Staff, Finance Staff, Cleaners etc.)
   - id Admin
   - scheme_id CPV
   - code 79610000/Admin
   - unit Commission
### ItemType - itemtype 
   - description Nominated Workers
   - id Nom
   - scheme_id CPV
   - code 79610000/Nom
   - unit Commission
### ItemType - itemtype 
   - description Fixed Term Role (on School Payroll)
   - id FTA
   - scheme_id CPV
   - code 79610000/FTA
   - unit Commission
