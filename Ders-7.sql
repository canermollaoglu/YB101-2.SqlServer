/*
USER DEFINED FUNCTIONS (Kullanýcý Tanýmlý Fonksiyonlar)
Bir dizi iþlemin kullanýcý tarafýndan yapýlmasýný saðlar.

Select sorgularý içerisinde kullanýlýrlar.
Bir fonksiyonun içerisinde Insert, Update, Delete iþlemleri yapýlmaz.

Türleri:
1-Scalar Valued Functions (Geriye tek bir deðer dönen) / avg, min, max, sum
2-Table Valued Functions (Geriye tablo(liste) dönen)
*/

--1-Scalar Valued Functions (Geriye tek bir deðer dönen)

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
--Go kullanarak bir batch'in sona erdiðini belirterek, içinde bulunduðumuz batch'in çalýþtýrýlmasýný saðlayabiliriz. Bu özellikle birden fazla komut içeren iþlemleri transactions, triggers, producedures, functions tanýmlarken kullanýlýr.

--dbo: Sql serverda dbo (database owner), veritabaný objelerini (tablo, sp, fonksiyon vb.) oluþtururken varsayýlan olarak atanmýþ bir kullanýcý adýdýr.

Select dbo.ToplamSonucuGetir(60,54)

--Dýþarýdan girilen bir ürün fiyatý için, girilen kdv oranýna göre kdvli fiyat hesaplayan bir fonskiyon yazalým.

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
--Dýþarýdan girilen EmployeeID ve Yýl bilgisine göre ilgili çalýþanýn toplam sipariþ adedini dönen bir fonksiyon yazalým.
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

--2-Table Valued Functions (Geriye tablo(liste) dönen)

/*
Create Function <fonksiyon adý>
(
<parametreler>
)
Returns Table
AS
<fonksiyonda yer alacak sorgu>
*/

--Dýþarýdan girilen çalýþan adýna göre tüm sipariþleri listeleyen bir fonksiyon yazalým.
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

--Bu fonksiyon türü geriye tablo döndüðü için tablo gibi sorgulanarak kullanýlýr.
Select * from dbo.OrdersByEmployeeName('Nancy Davolio')

--TRIGGER--
/*
Kullanýcý tarafýndan elle yapýlmak istenmeyen ya da gercekleþtirilmesi uzun sürebilen iþlemleri bir takým olaylardan SONRA (AFTER) ya da o olayýn YERÝNE (INSTEAD OF) sistem tarafýndan otomatik olarak yapýlmasýný saðlayan veritabaný yapýlarýdýr.

DML Trigger: Select, Insert, Update, Delete islemlerin yerine ya da bu iþlemlerden sonra 

DDL Trigger: Create, Alter, Drop iþlemlerinin yerine ya da bu iþlemlerden sonra
*/

--DML Trigger:
--Trigger'ýn Modlarý:
	--AFTER			: bir tabloya yapýlan iþlemden sonra çalýþýr.
	--INSTEAD OF	: bir tabloya yapýlmak istenen iþlemin yerine çalýþýr.

	--Kategoriler tablosuna yeni bir kategori eklendikten sonra tüm kayýtlarý gösteren bir trigger yazalým.
	use NORTHWND

	CREATE Trigger KategoriKontrol
	ON Categories --tablo adý
	AFTER INSERT	--trigger mod
	AS
	Select * from Categories --yapýlacak iþlem

	insert into Categories(CategoryName,Description) 
	values('Teknoloji','Tüm Teknoloji Ürünleri')

	--Bir ürün silmek istediðimizde silme iþlemini iptal ederek Discontinued alýnýný 0 olarak güncelleyelim.

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

	--Kategori tablosuna eklenen son kaydýn detaylarýný gösteren bir trigger oluþturalým:

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
	values('Elektronik','Tüm Elektronik Ürünleri')

	--Northwnd üzerinde herhangi bir shippers silmek istediðimizde silinebilir ancak tüm verinin yedeðinin StoreDB veritabanýnda St_Shippers adlý tabloya yedeklenmesi saðlanmalýdýr. 


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

	--Bu bilgileri StoreDB'deki St_Shippers tablosuna gönderelim.
	Insert into StoreDB.dbo.St_Shippers(KargoAdi,KargoTel)
	values(@silinenAd,@silinenTel)

	insert into Shippers values('Aras Kargo','50543434343')
	Select * from Shippers

	Delete from Shippers
	where ShipperID=4

	