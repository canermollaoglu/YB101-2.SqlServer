/*
CONSTRAINTS (K�s�tlar)

1- Primary Key Constraint
2- Foreign Key Constraint

3- Default Constraint
	Tabloda herhangi bir alana default de�er girebilmeyi sa�lar.
4- Check Constraint
	Tabloda herhangi bir alana sadece belirlenen kriterler kapsam�nda veri giri�i yap�lmas�n� sa�lar.
5- Unique Constraint
	Tabloda herhangi bir alan�n benzersiz olmas�n� sa�lar.
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

--Arac giri�i yap�l�rken negatif de�ere sahip bir Price girilemesin.
Alter table Car
ADD Constraint CHK_PriceControl CHECK(Price>=0)

Insert into Car (CarModel,PlateNumber,Price)
values('2023','34GZF201',-10000)

--IF KARAR YAPISI
--Ara� say�s� 10'dan fazla ise mesaj verelim.

Declare @sayi int
Set @sayi=(Select Sum(Stock) from Car)

IF(@sayi>=10 and @sayi<=50)
	BEGIN
	print '10 ile 50 aral���nda ara� bulunmaktad�r.'
	END
ELSE IF(@sayi<10)
	BEGIN
	print '10 dan az ara� bulunmaktad�r.'
	END
ELSE
	BEGIN
	print '50 den fazla ara� bulunmaktad�r.'
	END

	--CASE YAPISI

	Select CarModel,
	CASE
	WHEN Stock=1 THEN '1 adet ara� bulunmaktad�r'
	WHEN Stock=5 THEN '5 adet ara� bulunmaktad�r'
	END AS StockStatus
	from Car

	use NORTHWND

	--Kargo �irketlerimizin aras�nda Speedy Express ad�nda bir �irket varsa telefon numaras�n� (505) 343 43 43 olarak g�ncelleyiniz. Yoksa kargo firmas� bulunamad� mesaj� veriniz.
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
		print 'Kargo �irketi bulunamad�.'
		END