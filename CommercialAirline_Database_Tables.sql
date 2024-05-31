
CREATE TABLE AirplaneManufacturer(
                                  ManufacturerID  char(10) not null,
                                  ManufacturerName varchar(20),  
                                  Address         varchar(20),    
                                  Country         varchar(20),                                              
                                  PhoneNo         varchar(10),
                                  Email           varchar(20),
                                  PRIMARY KEY (ManufacturerID)
								  );

CREATE TABLE AirplaneSpecs(
                        RegistrationNo    char(10) not null, 
                        VIN       Char(17) not null,
                        Model     varchar(20) not null,
                        Year_Made Date,
                        Capacity  Integer,
                        ManufacturerID char(10),
                        PRIMARY KEY (RegistrationNo),
                        FOREIGN KEY  (ManufacturerID)REFERENCES AirplaneManufacturer(ManufacturerID)
  );

Create Table InsuranceProvider( 
                       ProviderID char(10) not null,
                       ProviderName Varchar(20),
                       ProviderPhoneNumber  Integer,
                       ProviderEmail varchar (20),
                       ProviderAddress varchar(20),
                       ProviderCountry char(10),
                       PRIMARY KEY (ProviderID),

  );

CREATE TABLE AircraftInsurance(
                          InsuranceID Char(10), 
                          InsuranceProvider char(10),
                          Issue_Date DATE,
                          Expiration_Date DATE,
                          PRIMARY KEY (InsuranceID),
						  FOREIGN KEY (InsuranceProvider) REFERENCES InsuranceProvider(ProviderID)
                          
);




CREATE TABLE OfficeLocations(  --Main Office, exclusive from airports
            OfficeID       char(10) not null,
            O_PhoneNumber  varchar(10),
            Address        varchar(20),
            Country        varchar(20),
            City           varchar(20),
            ZipCode        varchar(10), 
            Email          varchar(20),  
            WorkingHours   varchar(10),
            PRIMARY KEY(OfficeID)
			);

CREATE TABLE department(
                        DepartmentNumber       char(10) not null,
                        DepartmentName         varchar(20),
                        Location               varchar(20),
                        PRIMARY KEY (DepartmentNumber),

						);
CREATE TABLE passport(
            PassportNo			  varchar(10) not null,		
            VisaType			    varchar(20),
            City				      varchar(20),
            DOB					      DATE,
            PRIMARY KEY (PassportNo));

CREATE TABLE Customers(
            customerid			  char(10) not null, 
            FirstName				      varchar(20),
            MiddleInitial				      char(1),
            LastName				      varchar(20),
            Gender            varchar(20),
            CountryPhoneCode	varchar(4), 
            PhoneNo		        varchar(10),
            Email				      varchar(20), 
            SpecialCategory		varchar(20),
            address				    varchar(20),
            Country_Recidency	varchar(20),
            PassportNo		    varchar(10) not null,
            PRIMARY KEY (customerid),
			FOREIGN KEY (PassportNo) REFERENCES passport(PassportNo)
            );




CREATE TABLE employees(
            EmployeeID					  char(10) not null, 
            FirstName				      varchar(20),
            MiddleInitial				  char(1),
            LastName				      varchar(20),
            Essn				          Numeric(9,0),
            MgrId                 char(10), 
            DOB					          DATE,
            Gender                varchar(20),
            CountryPhoneCode      varchar(3),
            PhoneNo			          varchar(10),
            Email				          varchar(20),				
            Address			          varchar(20),
            PRIMARY KEY (EmployeeID),
			FOREIGN KEY (MgrID) references employees(EmployeeID)
  );         

CREATE TABLE pilots(
  EmployeeID           Char(10) not null,
  LicenseType          varchar(20),    
  Certification        Varchar(20),    
PRIMARY KEY (EmployeeID,LicenseType,Certification),
FOREIGN KEY (EmployeeID) references employees(EmployeeID)

);


CREATE TABLE DepartmentManager(
                        DepartmentNumber       char(10) not null,
                        MgrId                  char(10), 
                        MgrStartDate           DATE,
                        PRIMARY KEY (DepartmentNumber,MgrID),
                        FOREIGN KEY (DepartmentNumber) references department(DepartmentNumber),             
                        Foreign Key (MgrId) references employees(EmployeeID)
						);

CREATE TABLE airport(
            AirportID        CHAR(10) not null,  
            AirportName      varchar(20),
            OfficeID         Char(10), --Main Office in charge of airpot operations
            Address          varchar(20),
            Country          varchar(20),
            City             varchar(30),
            Classification   varchar(20), --National, International, Private
            PRIMARY KEY (AirportID),
			Foreign key (OfficeID) references OfficeLocations(OfficeID)
           );  

CREATE TABLE routes(
          RouteID              char(10) not null, 
          DepartureAirport     char(10),
          ArrivalAirport       char(10),  
          Duration		         Decimal (4,2),
          PRIMARY KEY(RouteID),
         Foreign Key (DepartureAirport) references airport(AirportID),
          Foreign Key (ArrivalAirport) references airport(AirportID),
  Check (DepartureAirport <> ArrivalAirport)
  );

  CREATE TABLE airplanes(
                       AirplaneID                Char(10) not null,  
                       InsuranceID               char(10),
                       RegistrationNo                Char(10),
                       PRIMARY KEY (AirplaneID),
					   FOREIGN KEY (InsuranceID) references AircraftInsurance(InsuranceID),
                       FOREIGN KEY (RegistrationNo) REFERENCES AirplaneSpecs(RegistrationNo)
                       
  );

CREATE TABLE flights(
           FlightID       char(10) not null,
           RouteID        char(10) not null,
           DepartureDate  DATE,
           DepartureTime  TIME,
           ArrivalDate    DATE,
           ArrivalTime    TIME,
           Gate           varchar(5),
           Duration       Decimal (4,2),
           AirplaneID     char(10) not null,
           PRIMARY KEY(FlightID,DepartureDate), --Assuming ID can repeat, but not in the same day
		   FOREIGN KEY(RouteID) references routes(RouteID),
           FOREIGN KEY (AirplaneID) references airplanes(AirplaneID)
   );        


 CREATE TABLE Seats(   
                    SeatID                  INTEGER not null,
					AirplaneID              Char(10) not null, 
                    SeatNo                  char(3) not null,
                    CabinClass               varchar(20),   
                    EstimatedPrice          decimal(8,2)    
                    PRIMARY KEY (SeatID),    
                    FOREIGN KEY (AirplaneID) references airplanes(AirplaneID)
  );

CREATE TABLE tickets(
           Ticket_ID         Char(10) not null,
           CustomerID        char(10) not null,
           FlightID          char(10), 
		   FlightDate        DATE,
           BookingDate       DATE,
           Price             decimal(8,2),             
           SeatID            INTEGER not null, 
		   
            PRIMARY KEY(Ticket_ID),
			FOREIGN KEY (FlightID,FlightDate) references flights(FlightID,DepartureDate),
            FOREIGN KEY (CustomerID) references Customers(customerid),
            FOREIGN KEY (SeatID) references Seats(SeatID),

            
  );


  Create Table Cards(     --'Card info stored for faster purchases and Miles_rewards'
                      Card_Number                 varchar(20),      
                      Card_Expiration_Date        Date, 
                      CostumerID                  char(10),
                      PRIMARY KEY (Card_Number),
                      Foreign Key (CostumerID) References Customers(customerid)
  );


CREATE TABLE payments( 
                      Receipt_No                  char(10),                  
                      Payment_Date                Date,                 
                      Payment_Time                Time,     
                      Transaction_Method          varchar(20),          
                      Amount                      decimal(8,2),             
                      DiscountCode               varchar(20), 
                      Card_No                     varchar(20),  
                      CustomerID                  char(10),
                      PRIMARY KEY (Receipt_No),
                      Foreign Key (CustomerID) References customers(customerid),
                      Foreign key (Card_No) references Cards(Card_Number)
  );


                     
  
CREATE TABLE LoyaltyProgram(
                            LoyaltyNo         char(10) not null,          
                            Card_Number       varchar(20), 
                            DateSubscribed    date,  
                            ExpirationDate    date,
                            PRIMARY KEY (LoyaltyNo),
                            FOREIGN KEY (Card_Number) references Cards(Card_Number)
);

CREATE TABLE Miles_Reward(
                          LoyaltyNo Char(10),
                          TicketID Char(10),
                          Miles_Earned INTEGER,
                          Miles_Used INTEGER, --'every positive or negative transaction of miles'
                          PRIMARY KEY (LoyaltyNo, TicketID),
						FOREIGN KEY (LoyaltyNo) REFERENCES LoyaltyProgram(LoyaltyNo),
                          FOREIGN KEY (TicketID) REFERENCES tickets(Ticket_ID)
);

  CREATE TABLE Discounts(
                          PromoCode        char(10) not null,
                          PercentageDiscount  Decimal(3,2),
                          Expiration_Date     date,
                          LoyaltyNo           Char(10),
                          EmployeeID          Char(10),
                          PRIMARY KEY (PromoCode), 
                          FOREIGN KEY (LoyaltyNo) REFERENCES LoyaltyProgram(LoyaltyNo),
                          FOREIGN KEY (EmployeeID) REFERENCES employees(EmployeeID),
    CONSTRAINT MaxDiscount CHECK (PercentageDiscount <= 0.50)
	);

	Create Table Suppliers(
                    SupplierID Char(10) not null,
                    SupplierName Varchar(20),
                    SupplierAddress Varchar(20),
                    SupplierCountry Varchar(20),
                    SupplierCity Varchar(20),
                    SupplierNumber Integer,
                    SupplierEmail Varchar(20),
                    Type varchar(20),
                    Primary Key (SupplierID)
);

CREATE TABLE   Maintenance( 
                          MaintenanceID Char(10),
                          AirplaneID Char(10) not null,
                          MaintenanceDate  date,
                          MaintenanceType varchar(14),
                          Estimated_Cost  decimal(10,2),
                          SupervisorID char(10),
                          Primary Key (MaintenanceID),
                         Foreign Key (AirplaneID) references airplanes(AirplaneID),
                          Foreign Key (SupervisorID) references employees(EmployeeID)
);

Create Table Parts(
                    PartNo char(10) not null,  
                    PartName Varchar(20),
                    AirplanePartLocation Varchar(20),
                    PartCost Decimal(10,2),
                    FlightsBeforeChange Integer,
                    SupplierID Char(10),
                    DateBought Date,
                    Primary Key (PartNo),
		            Foreign Key (SupplierID) References Suppliers(SupplierID)
                    
);

Create Table MaintenanceOrder(
                              OrderID Char(10) Not null,
                              OrderDate Date,
                              MaintenanceID Char(10),
                              Primary Key (OrderID),
							  Foreign Key (MaintenanceID) references Maintenance(MaintenanceID)
                             );
CREATE TABLE PartsUsed(
                        PartNo Char(10),
                        OrderID Char(10),
                        Quantity Integer,
                        PRIMARY KEY (PartNo, OrderID),
						Foreign Key (PartNo) references Parts(PartNo),
                        Foreign Key (OrderID) references MaintenanceOrder(OrderID)
                       
);

  CREATE TABLE payroll(
                          PayrollNo Integer not null,
                          EmployeeID char(10) not null,
                          PaymentDate date,
                          PayrollType varchar(14),
                          Amount decimal(8,2),
                          HoursWorked decimal(5,2) not null, 
                          OvertimePayed decimal(8,2),
                          OfficeID char(10),      --'to know office in charge of issuing payment'
                          Primary Key (PayrollNo),
                          Foreign Key (EmployeeID) references employees(EmployeeID),
                          Foreign Key (OfficeID) references OfficeLocations(OfficeID),
  OvertimeHours AS (
    CASE 
        WHEN HoursWorked > 40 THEN HoursWorked - 40 
        ELSE 0 
    END)
                          );
  CREATE TABLE Salary(
                          EmployeeID char(10) not null,
                          JobTitle Varchar(16) not null,
                          Salary decimal(8,2) not null,
                          Date_Updated date,
                          Date_hired date,
                          Primary Key (EmployeeID,JobTitle),--'Employee could have multiple responsibilities with different hourly rates'
                          Foreign Key (EmployeeID) References employees(EmployeeID)
  );
 Create Table GasSupplier( 
                          GasSupplierID char(10) not null,
                          GasSupplierName Varchar(20),
                          GasSupplierPhoneNumber  Integer,
                          GasSupplierEmail varchar (20),
                          GasSupplierAddress varchar(20),
                          GasSupplierCountry char(10),
						  PRIMARY KEY (GasSupplierID)
  );
 CREATE TABLE gas(
                          ReceiptID char(10) not null,
                          GasType varchar(20),
                          Amount  decimal(8,2) not null, --'amount of fueled gas in liters'
                          Cost decimal (10,2) not null,
                          AirplaneID char(10),
                          dateProvided date,
                          GasSupplierID char(10) not null,
                          Primary Key (ReceiptID),
                          Foreign Key (AirplaneID) references airplanes(AirplaneID),
                          Foreign Key (GasSupplierID) references GasSupplier(GasSupplierID)
);


  CREATE TABLE   Luggage(
                          LuggageID Char(10) not null,
                          LuggageType varchar(20),
                          Weight		decimal(4,2),
                          CustomerID char(10),
                          FlightID char(10),
						  FlightDate date,
                          LuggageCost decimal(6,2) not null,
                          Primary Key (LuggageID),
                          Foreign Key (FlightID,FlightDate) references flights(FlightID,DepartureDate),
                          Foreign Key (CustomerID) references customers(customerid),
						  OverweightCost AS (CASE WHEN Weight > 50 THEN LuggageCost + 100 ELSE LuggageCost END)
                          );



Create table   Crew_members(
                          EmployeeID char(10),
                          FlightID char(10),
                          FlightDate date,
                          JobTitle varchar(16),
                          Primary Key (EmployeeID,FlightID,FlightDate),
                          Foreign Key (EmployeeID) references employees(EmployeeID),
                          Foreign Key (FlightID,FlightDate) References flights(FlightID,DepartureDate)
  );
  


CREATE TABLE Complaints(
                          ComplaintID Char(10),
                          CustomerID Char(10),
                          ComplaintDate DATE,
                          ComplaintType VARCHAR(30),
                          Status VARCHAR(16),
                          PRIMARY KEY (ComplaintID),
                          FOREIGN KEY (CustomerID) REFERENCES customers(customerid)
                          
);

CREATE TABLE Destination_Requirements(
                          RouteID Char(10),
                          VisaRequired  varchar(3) not null,
                          RequiredDocumentation Varchar(20) --'assuming only one or no document is required'
                          PRIMARY KEY (RouteID)
						  Foreign Key (RouteID) References routes(RouteID)
);
CREATE TABLE ServiceProvider(
                          ServiceProviderID Char(10),
                          ServiceType VARCHAR(20),--'revisar'
                          Description varchar(20),
                          Cost DECIMAL(6, 2),
                          ProviderPhoneNumber  Integer,
                          ProviderEmail varchar (20),
                          PRIMARY KEY (ServiceProviderID,ServiceType)
);
CREATE TABLE InflightServices(
                          ServiceID Char(10) ,
                          ServiceProviderID Char(10),
						  ServiceType Varchar(20),
                          FlightID Char(10),
                          FlightDate DATE,
                          PRIMARY KEY (ServiceID),
                          Foreign Key (FlightID,FlightDate) References flights(FlightID,DepartureDate),
						  FOREIGN KEY (ServiceProviderID,ServiceType) References ServiceProvider(ServiceProviderID,ServiceType)
);




CREATE TABLE Delays(
                    DelayID Char(10),
                    FlightID Char(10),
                    FlightDate DATE,
                    DelayTime Decimal(4,2),
                    DelayReason VARCHAR(20),
                    NewDepartureTime TIME,
                    NewArrivalTime TIME,
                    PRIMARY KEY (DelayID),
					FOREIGN KEY (FlightID,FlightDate) References flights(FlightID,DepartureDate)
                    ); 
