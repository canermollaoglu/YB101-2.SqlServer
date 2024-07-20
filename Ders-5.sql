/*
CONSTRAINTS (Kýsýtlar)

1- Primary Key Constraint
2- Foreign Key Constraint

3- Default Constraint
	Tabloda herhangi bir alana default deðer girebilmeyi saðlar.
4- Check Constraint
	Tabloda herhangi bir alana sadece belirlenen kriterler kapsamýnda veri giriþi yapýlmasýný saðlar.
5- Unique Constraint
	Tabloda herhangi bir alanýn benzersiz olmasýný saðlar.
*/

Create Database CarRental
use CarRental

Create Table Car(
CarID int primary key identity(1,1),
CarModel date not null Constraint Chk_CarModel CHECK(Datediff(year,CarModel,getdate())<=10),
Stock int DEFAULT 1,
PlateNumber varchar(12) UNIQUE,
Price decimal
)

Alter Table Car
alter column Price decimal(18,2)

--Tum constraitleri test edelim:

--Check Constraint: 
Insert into Car 
values('2023',5,'34GZF209',2000000.50)

select * from Car

--Default Constraint:
Insert into Car (CarModel,PlateNumber,Price)
values('2023','34GZF200',2000000.50)

--Unique Constraint:
Insert into Car (CarModel,PlateNumber,Price)
values('2023','34GZF200',2000000.50)

--Arac giriþi yapýlýrken negatif deðere sahip bir Price girilemesin.
Alter table Car
ADD Constraint CHK_PriceControl CHECK(Price>=0)

Insert into Car (CarModel,PlateNumber,Price)
values('2023','34GZF201',-10000)

--IF KARAR YAPISI
--Araç sayýsý 10'dan fazla ise mesaj verelim.

Declare @sayi int
Set @sayi=(Select Sum(Stock) from Car)

IF(@sayi>=10 and @sayi<=50)
	BEGIN
	print '10 ile 50 aralýðýnda araç bulunmaktadýr.'
	END
ELSE IF(@sayi<10)
	BEGIN
	print '10 dan az araç bulunmaktadýr.'
	END
ELSE
	BEGIN
	print '50 den fazla araç bulunmaktadýr.'
	END

	--CASE YAPISI

	Select CarModel,
	CASE
	WHEN Stock=1 THEN '1 adet araç bulunmaktadýr'
	WHEN Stock=5 THEN '5 adet araç bulunmaktadýr'
	END AS StockStatus
	from Car

	use NORTHWND

	--Kargo þirketlerimizin arasýnda Speedy Express adýnda bir þirket varsa telefon numarasýný (505) 343 43 43 olarak güncelleyiniz. Yoksa kargo firmasý bulunamadý mesajý veriniz.
	Select * from Shippers

	Declare @id int
	Set @id=(Select ShipperID from Shippers
	where CompanyName='Speedy Express' )

	IF(@id is not null)
		BEGIN
		UPDATE Shippers
		Set Phone='(505) 343 43 43'
		where ShipperID=@id
		END
	ELSE
		BEGIN
		print 'Kargo þirketi bulunamadý.'
		END