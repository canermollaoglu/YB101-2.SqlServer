/*
STORED PROCEDURE (Saklý Yordam)
Sql Server üzerinde bir sorgu çalýþýrken aþaðýdaki aþamalardan geçer:

1-Parse		: syntax kontrolü yapýlýr.
2-Resolve	: Tablo ve sutunlar kontrol edilir.
3-Optimize	: Kayýt nasýl geriye döndürülecek. (index)
4-Compile	: Sorgu sonucunun derlenmesi
5-Execute	: Sorgunun çalýþtýrýlýp sonucun döndürülmesi.

--SP'ler DB'de Compile Kod olarak saklanýr. Çalýþtýrýldýðýnda tekrar derlenmeden hýzlý bir þekilde çalýþýr

Neden Kullanýrýz:
Performans, Tekrar Kullanabilme, Güvenlik
*/
--Procedure Oluþturma
use NORTHWND

--Create Procedure <Procedure Adý>
--AS
--<procedure içerisinde yer alacak olan sorgular>

--Procedure Çalýþtýrma
--Execute <Procedure Adý>
--Exec <Procedure Adý>

--Tüm kategorileri listeleyen bir procedure yapalým

use NORTHWND
Create Proc Sp_KategorileriListesi
AS
Select * from Categories

exec Sp_KategorileriListesi

--Dýþarýdan girilen kategori adý ve açýklamaya göre yeni bir kategori ekleyen bir sp yazalým.

Create Proc Sp_KategoriEkle(
@KategoriAdi nvarchar(100),
@Aciklama nvarchar(200)
)
AS
Insert into Categories(CategoryName,Description) 
values(@KategoriAdi,@Aciklama)

Exec Sp_KategoriEkle 'Teknoloji','Tüm Teknoloji Ürünleri'

--Dýþarýdan girilen yüzde miktarýna göre tüm ürünlere zam yapan bir sp yazalým.

ALTER Proc Sp_ZamYap(
@ZamOrani tinyint
)
As
UPDATE Products
set UnitPrice=UnitPrice+(@ZamOrani*UnitPrice/100)

Select * from Products
exec Sp_ZamYap 10

--Girilen kategori adýna göre tüm ürünleri listeleyen bir procedure yazalým.

Alter Proc Sp_ProductsByCategoryName
(
@CategoryName nvarchar(100)
)
AS
Select ProductID,ProductName,c.CategoryID,CategoryName,UnitPrice,UnitsInStock
from Products p
inner join Categories c
on c.CategoryID=p.CategoryID
where c.CategoryName=@CategoryName

Exec Sp_ProductsByCategoryName 'Beverages'

/*
Stok miktarý dýþarýdan girilen iki deðer arasýnda olan,
Ürün fiyatý dýþarýdan girilen iki deðer arasýnda olan,
tedarikçi firma adý dýþarýdan girilen deðeri içeren ürünleri,
Ürün Adý, Fiyatý, %10 Kdvli Fiyatý, Stok Miktarý ve Tedarikçi firma adý þeklinde listeleyen bir sp yazalým.
*/

Create Proc Sp_GetAllProducts(
@minStock int,
@maxStock int,
@minPrice money,
@maxPrice money,
@cmpName nvarchar(50)
)
AS
Select * 
from Products p
inner join Suppliers s
on s.SupplierID=p.SupplierID
where (UnitsInStock between @minStock and @maxStock) and
(UnitPrice between @minPrice and @maxPrice) and 
CompanyName like '%'+@cmpName+'%'

Exec Sp_GetAllProducts 5,50,1,500,'xot'

--Belirli bir tarihden (yýl) sonra sipariþ veren müþterilerin detaylarýný getiren ve ayný zamanda sipariþlerin toplam tutarlarýný hesaplayan bir sp yazýnýz. (CustomerID,CompanyName,OrderID,OrderDate,Total)

Alter Proc Sp_OrderDetailsbyDate(
@startDate date
)
as
SELECT 
	c.CustomerID,
	c.CompanyName,
	o.OrderID,
	o.OrderDate,
	ROUND(SUM(od.UnitPrice*od.Quantity*(1-od.Discount)),2)
FROM 
	Orders o
	join Customers c on c.CustomerID=o.CustomerID
	join [Order Details] od on od.OrderID=o.OrderID
WHERE 
	YEAR(OrderDate) >=YEAR(@startDate)
GROUP BY 
	c.CustomerID,
	c.CompanyName,
	o.OrderID,
	o.OrderDate
ORDER BY CustomerID

exec Sp_OrderDetailsbyDate '1998'