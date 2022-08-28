-- 1) create database
CREATE DATABASE CustomerOrderViewer;

-- 2) set it active for subsequent commands
USE CustomerOrderViewer;

-- 3) create tables
CREATE TABLE [dbo].[Customer] (
	CustomerId INT IDENTITY(1, 1) NOT NULL,
	FirstName VARCHAR(50) NOT NULL,
	MiddleName VARCHAR(50) NULL,
	LastName VARCHAR(50) NOT NULL,
	Age INT NOT NULL,
	PRIMARY KEY (CustomerId)
);

CREATE TABLE [dbo].[Item] (
	ItemId INT IDENTITY(1, 1) NOT NULL,
	[Description] VARCHAR(100) NOT NULL,
	Price DECIMAL(4, 2) NOT NULL,
	PRIMARY KEY (ItemId)
);

CREATE TABLE [dbo].[CustomerOrder] (
	CustomerOrderId INT IDENTITY(1, 1) NOT NULL,
	CustomerId INT NOT NULL,
	ItemId INT NOT NULL,
	PRIMARY KEY (CustomerOrderId),
	FOREIGN KEY (CustomerId) REFERENCES Customer(CustomerId), --ON DELETE CASCADE,
	FOREIGN KEY (ItemId) REFERENCES Item(ItemId), --ON DELETE CASCADE
);

-- dbo is the schema.  there can be many schemas each with there own tables.
-- add schemas under Security/Schemas
-- below is example of creating table under a different schema.
CREATE TABLE [test].[Item] (
	ItemId INT IDENTITY(1, 1) NOT NULL,
	[Description] VARCHAR(100) NOT NULL,
	Price DECIMAL(4, 2) NOT NULL,
	PRIMARY KEY (ItemId)
);

-- 4) fill tables
INSERT INTO [dbo].[Customer] (FirstName, MiddleName, LastName, Age) VALUES('Edsel', NULL, 'Clarin', 50);
INSERT INTO [dbo].[Customer] (FirstName, MiddleName, LastName, Age) VALUES('Eileen', NULL, 'Clarin', 48);
INSERT INTO [dbo].[Customer] (FirstName, MiddleName, LastName, Age) VALUES('Carina', NULL, 'Clarin', 14);
INSERT INTO [dbo].[Customer] (FirstName, MiddleName, LastName, Age) VALUES('Nia', NULL, 'Clarin', 12);

INSERT INTO [dbo].[Item] ([Description], Price) VALUES('Duracell AA Batteries', 15.99);
INSERT INTO [dbo].[Item] ([Description], Price) VALUES('Dr Pepper', 9.99);
INSERT INTO [dbo].[Item] ([Description], Price) VALUES('Pepsi', 9.99);
INSERT INTO [dbo].[Item] ([Description], Price) VALUES('Sprite', 9.99);
INSERT INTO [dbo].[Item] ([Description], Price) VALUES('Hebrew National Hot Dogs', 7.99);
INSERT INTO [dbo].[Item] ([Description], Price) VALUES('Heinz Mustard', 4.99);

INSERT INTO [dbo].[CustomerOrder] (CustomerId, ItemId) VALUES(1, 1);
INSERT INTO [dbo].[CustomerOrder] (CustomerId, ItemId) VALUES(1, 2);
INSERT INTO [dbo].[CustomerOrder] (CustomerId, ItemId) VALUES(1, 3);
INSERT INTO [dbo].[CustomerOrder] (CustomerId, ItemId) VALUES(1, 4);
INSERT INTO [dbo].[CustomerOrder] (CustomerId, ItemId) VALUES(1, 5);
INSERT INTO [dbo].[CustomerOrder] (CustomerId, ItemId) VALUES(1, 6);
INSERT INTO [dbo].[CustomerOrder] (CustomerId, ItemId) VALUES(2, 2);
INSERT INTO [dbo].[CustomerOrder] (CustomerId, ItemId) VALUES(2, 3);
INSERT INTO [dbo].[CustomerOrder] (CustomerId, ItemId) VALUES(2, 5);
INSERT INTO [dbo].[CustomerOrder] (CustomerId, ItemId) VALUES(2, 6);
INSERT INTO [dbo].[CustomerOrder] (CustomerId, ItemId) VALUES(3, 3);
INSERT INTO [dbo].[CustomerOrder] (CustomerId, ItemId) VALUES(4, 3);

-- 5) NOTE: weak entity vs strong entity and cascading delete
-- strong entity is table that can exists by itself (ex. Item)
-- weak entity is a table that can't exists by itself (ex. CustomerOrderId)
-- if 'ON CASCADE DELETE' is added to a foreign key and an item is dropped in a strong entity, 
-- it will drop the items in a weak entity.
-- Example:
-- SELECT * FROM [dbo].[CustomerOrder] WHERE ItemId = 3;
-- DELETE FROM [dbo].[Item] WHERE ItemId = 3;  // rows from CustomerOrder will be deleted as well
-- there are advantages and disdvantages of this.  
-- in real world, data may need to be retained.  soft delete (set a flag) is a better way to do.
-- this is a design time consideration.

-- 6) view
CREATE VIEW [dbo].[CustomerOrderDetail] AS
	SELECT 
		T1.CustomerOrderId, 
		T2.CustomerId, 
		T3.ItemId, 
		T2.FirstName, 
		T2.LastName, 
		T3.[Description], 
		T3.Price  
	FROM 
		[dbo].[CustomerOrder] T1
	INNER JOIN 
		[dbo].[Customer] T2 ON T1.CustomerId = T2.CustomerId
	INNER JOIN 
		[dbo].[Item] T3 ON T1.ItemId = T3.ItemId

-- clear database
DELETE FROM [dbo].[CustomerOrder];
DELETE FROM [dbo].[Item];
DELETE FROM [dbo].[Customer];
DELETE FROM [test].[Item];
DROP TABLE [dbo].[CustomerOrder];
DROP TABLE [dbo].[Item];
DROP TABLE [dbo].[Customer];
DROP TABLE [test].[Item];
