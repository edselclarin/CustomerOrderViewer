-- 1) set it active for subsequent commands
USE CustomerOrderViewer;
GO

-- 2) 
ALTER TABLE [dbo].[CustomerOrder] 
ADD 
	CreateDate DATETIME NOT NULL DEFAULT(GETDATE()),
	CreateId VARCHAR(50) NOT NULL DEFAULT('System'),
	UpdateDate DATETIME NOT NULL DEFAULT(GETDATE()),
	UpdateId VARCHAR(50) NOT NULL DEFAULT('System'),
	ActiveInd BIT NOT NULL DEFAULT(CONVERT(BIT, 1))
GO

-- 3) User Defined Table Type (UDTT) 
CREATE TYPE [dbo].CustomerOrderType AS TABLE
(
	CustomerOrderId INT NOT NULL,
	CustomerId INT NOT NULL,
	ItemID INT NOT NULL
);
GO

-- 3) add ActiveInd column to the view
ALTER VIEW [dbo].[CustomerOrderDetail] AS
	SELECT 
		T1.CustomerOrderId, 
		T2.CustomerId, 
		T3.ItemId, 
		T2.FirstName, 
		T2.LastName, 
		T3.[Description], 
		T3.Price,
		T1.ActiveInd
	FROM 
		[dbo].[CustomerOrder] T1
	INNER JOIN 
		[dbo].[Customer] T2 ON T1.CustomerId = T2.CustomerId
	INNER JOIN 
		[dbo].[Item] T3 ON T1.ItemId = T3.ItemId
GO

-- 4) create stored procedure to query the view
CREATE PROCEDURE [dbo].[CustomerOrderDetail_Get] AS
	SELECT 
		CustomerOrderId, 
		CustomerId, 
		ItemId, 
		FirstName, 
		LastName, 
		[Description], 
		Price
	FROM 
		[dbo].[CustomerOrderDetail]
	WHERE
		ActiveInd = CONVERT(BIT, 1)
GO

-- 5) create stored procedure to delete order
CREATE PROCEDURE [dbo].[CustomerOrderDetail_Delete]
	@CustomerOrderId INT,
	@UserId VARCHAR(50)
AS
	UPDATE
		[dbo].[CustomerOrder] 
	SET 
		ActiveInd = CONVERT(BIT, 0),
		UpdateId = @UserId,
		UpdateDate = GETDATE()
	WHERE 
		CustomerOrderId = @CustomerOrderId AND
		ActiveInd = CONVERT(BIT, 1)
GO

-- 6) create UPSERT  procedure
CREATE PROCEDURE [dbo].[CustomerOrderDetail_Upsert]
	@CustomerOrderType CustomerOrderType READONLY,
	@UserId VARCHAR(50)
AS
	MERGE INTO CustomerOrder TARGET
	USING
	(
		SELECT
			CustomerOrderId,
			CustomerId,
			ItemId,
			@UserId [UpdateId],
			GETDATE() [UpdateDate],
			@UserId [CreateId],
			GETDATE() [CreateDate]
		FROM
			@CustomerOrderType
	) AS SOURCE
	ON
	(
		-- COALESCE just in case SOURCE.CustomerOrderId is null then default value is -1.
		TARGET.CustomerOrderId = COALESCE(SOURCE.CustomerOrderId, -1)
	)
	WHEN MATCHED THEN
		UPDATE SET
			TARGET.CustomerId = SOURCE.CustomerId,
			TARGET.ItemId = SOURCE.ItemId,
			TARGET.UpdateId = SOURCE.UpdateId,
			TARGET.UpdateDate = SOURCE.UpdateDate
	WHEN NOT MATCHED BY TARGET THEN
		INSERT (CustomerId, ItemId, CreateId, CreateDate, UpdateId, UpdateDate, ActiveInd)
		VALUES (SOURCE.CustomerId, SOURCE.ItemId, SOURCE.CreateId, SOURCE.CreateDate, SOURCE.UpdateId, SOURCE.UpdateDate, CONVERT(BIT, 1));
GO

-- 7) create stored procedure to get list of customers
CREATE PROCEDURE [dbo].[Customers_Get]
AS
	SELECT
		*
	FROM
		[dbo].[Customer]

-- 8) create stored procedure to get list of items
CREATE PROCEDURE [dbo].[Item_Get]
AS
	SELECT
		*
	FROM
		[dbo].[Item]

