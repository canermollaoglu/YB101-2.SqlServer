/*
USER DEFINED FUNCTIONS (Kullan�c� Tan�ml� Fonksiyonlar)
Bir dizi i�lemin kullan�c� taraf�ndan yap�lmas�n� sa�lar.

Select sorgular� i�erisinde kullan�l�rlar.
Bir fonksiyonun i�erisinde Insert, Update, Delete i�lemleri yap�lmaz.

T�rleri:
1-Scalar Valued Functions (Geriye tek bir de�er d�nen) / avg, min, max, sum
2-Table Valued Functions (Geriye tablo(liste) d�nen)
*/

--1-Scalar Valued Functions (Geriye tek bir de�er d�nen)

Create function ToplamSonucuGetir(
@sayi1 int,
@sayi2 int
)
RETURNS INT
AS
BEGIN
return @sayi1+@sayi2
END

go
--Go kullanarak bir batch'in sona erdi�ini belirterek, i�inde bulundu�umuz batch'in �al��t�r�lmas�n� sa�layabiliriz. Bu �zellikle birden fazla komut i�eren i�lemleri transactions, triggers, producedures, functions tan�mlarken kullan�l�r.

--dbo: Sql serverda dbo (database owner), veritaban� objelerini (tablo, sp, fonksiyon vb.) olu�tururken varsay�lan olarak atanm�� bir kullan�c� ad�d�r.

Select dbo.ToplamSonucuGetir(60,54)

--D��ar�dan girilen bir �r�n fiyat� i�in, girilen kdv oran�na g�re kdvli fiyat hesaplayan bir fonskiyon yazal�m.

alter Function KdvliFiyat(
@kdvOrani tinyint,
@birimFiyat money
)
Returns money
as
Begin
return @birimFiyat+(@kdvOrani*@birimFiyat/100)
end

Select dbo.KdvliFiyat(20,1500)

Select 
	ProductID,
	ProductName,
	UnitPrice,
	dbo.KdvliFiyat(20,UnitPrice) KdvliFiyat 
from Products
go
--D��ar�dan girilen EmployeeID ve Y�l bilgisine g�re ilgili �al��an�n toplam sipari� adedini d�nen bir fonksiyon yazal�m.
Create Function EmployeeTotalOrder
(
@EmployeeID int,
@Year date
)
returns int
as
begin
	return (
	Select Count(*) from Orders 
	where EmployeeID=@EmployeeID 
	and Year(OrderDate)=Year(@Year))
end

go

Select dbo.EmployeeTotalOrder(2,'1996')

--2-Table Valued Functions (Geriye tablo(liste) d�nen)

/*
Create Function <fonksiyon ad�>
(
<parametreler>
)
Returns Table
AS
<fonksiyonda yer alacak sorgu>
*/

--D��ar�dan girilen �al��an ad�na g�re t�m sipari�leri listeleyen bir fonksiyon yazal�m.
go
Create Function OrdersByEmployeeName
(
@adSoyad nvarchar(100)
)
Returns table
as
RETURN(
Select FirstName+' '+LastName AdSoyad,OrderID
from Orders o
join Employees e on e.EmployeeID=o.EmployeeID
where FirstName+' '+LastName=@adSoyad
)

--Bu fonksiyon t�r� geriye tablo d�nd��� i�in tablo gibi sorgulanarak kullan�l�r.
Select * from dbo.OrdersByEmployeeName('Nancy Davolio')

--TRIGGER--
/*
Kullan�c� taraf�ndan elle yap�lmak istenmeyen ya da gercekle�tirilmesi uzun s�rebilen i�lemleri bir tak�m olaylardan SONRA (AFTER) ya da o olay�n YER�NE (INSTEAD OF) sistem taraf�ndan otomatik olarak yap�lmas�n� sa�layan veritaban� yap�lar�d�r.

DML Trigger: Select, Insert, Update, Delete islemlerin yerine ya da bu i�lemlerden sonra 

DDL Trigger: Create, Alter, Drop i�lemlerinin yerine ya da bu i�lemlerden sonra
*/

--DML Trigger:
--Trigger'�n Modlar�:
	--AFTER			: bir tabloya yap�lan i�lemden sonra �al���r.
	--INSTEAD OF	: bir tabloya yap�lmak istenen i�lemin yerine �al���r.

	--Kategoriler tablosuna yeni bir kategori eklendikten sonra t�m kay�tlar� g�steren bir trigger yazal�m.
	use NORTHWND

	CREATE Trigger KategoriKontrol
	ON Categories --tablo ad�
	AFTER INSERT	--trigger mod
	AS
	Select * from Categories --yap�lacak i�lem

	insert into Categories(CategoryName,Description) 
	values('Teknoloji','T�m Teknoloji �r�nleri')

	--Bir �r�n silmek istedi�imizde silme i�lemini iptal ederek Discontinued al�n�n� 0 olarak g�ncelleyelim.

	Create Trigger Urunkontrol
	on Products
	INSTEAD OF DELETE
	AS
	Update Products
	set Discontinued=0
	where ProductID=(Select ProductID from deleted)

	select * from Products

	Delete from Products
	where ProductID=5

	--Trigger Silme
	Drop trigger Urunkontrol

	--Trigger Aktif / Pasif
	Disable trigger Urunkontrol on Products
	Enable trigger Urunkontrol on Products

	--Kategori tablosuna eklenen son kayd�n detaylar�n� g�steren bir trigger olu�tural�m:

	Create Trigger CategoryLastInsertControl
	on Categories
	after insert
	as
	Declare @id int

	Select @id=CategoryID 
	from inserted

	Select * from Categories 
	where CategoryID=@id

	insert into Categories(CategoryName,Description) 
	values('Elektronik','T�m Elektronik �r�nleri')

	--Northwnd �zerinde herhangi bir shippers silmek istedi�imizde silinebilir ancak t�m verinin yede�inin StoreDB veritaban�nda St_Shippers adl� tabloya yedeklenmesi sa�lanmal�d�r. 


	Create database StoreDB
	use StoreDB

	Create Table St_Shippers
	(
	KargoID int primary key identity(1,1),
	KargoAdi nvarchar(120),
	KargoTel char(11)
	)

	use NORTHWND

	Create Trigger ShippersBackup
	on Shippers
	after delete
	as
	Declare @silinenAd nvarchar(120)
	Declare @silinenTel char(11)

	Select @silinenAd=CompanyName,@silinenTel=Phone from deleted

	--Bu bilgileri StoreDB'deki St_Shippers tablosuna g�nderelim.
	Insert into StoreDB.dbo.St_Shippers(KargoAdi,KargoTel)
	values(@silinenAd,@silinenTel)

	insert into Shippers values('Aras Kargo','50543434343')
	Select * from Shippers

	Delete from Shippers
	where ShipperID=4

	