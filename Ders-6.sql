/*
STORED PROCEDURE (Sakl� Yordam)
Sql Server �zerinde bir sorgu �al���rken a�a��daki a�amalardan ge�er:

1-Parse		: syntax kontrol� yap�l�r.
2-Resolve	: Tablo ve sutunlar kontrol edilir.
3-Optimize	: Kay�t nas�l geriye d�nd�r�lecek. (index)
4-Compile	: Sorgu sonucunun derlenmesi
5-Execute	: Sorgunun �al��t�r�l�p sonucun d�nd�r�lmesi.

--SP'ler DB'de Compile Kod olarak saklan�r. �al��t�r�ld���nda tekrar derlenmeden h�zl� bir �ekilde �al���r

Neden Kullan�r�z:
Performans, Tekrar Kullanabilme, G�venlik
*/
--Procedure Olu�turma
use NORTHWND

--Create Procedure <Procedure Ad�>
--AS
--<procedure i�erisinde yer alacak olan sorgular>

--Procedure �al��t�rma
--Execute <Procedure Ad�>
--Exec <Procedure Ad�>

--T�m kategorileri listeleyen bir procedure yapal�m

use NORTHWND
Create Proc Sp_KategorileriListesi
AS
Select * from Categories

exec Sp_KategorileriListesi

--D��ar�dan girilen kategori ad� ve a��klamaya g�re yeni bir kategori ekleyen bir sp yazal�m.

Create Proc Sp_KategoriEkle(
@KategoriAdi nvarchar(100),
@Aciklama nvarchar(200)
)
AS
Insert into Categories(CategoryName,Description) 
values(@KategoriAdi,@Aciklama)

Exec Sp_KategoriEkle 'Teknoloji','T�m Teknoloji �r�nleri'

--D��ar�dan girilen y�zde miktar�na g�re t�m �r�nlere zam yapan bir sp yazal�m.

ALTER Proc Sp_ZamYap(
@ZamOrani tinyint
)
As
UPDATE Products
set UnitPrice=UnitPrice+(@ZamOrani*UnitPrice/100)

Select * from Products
exec Sp_ZamYap 10

--Girilen kategori ad�na g�re t�m �r�nleri listeleyen bir procedure yazal�m.

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
Stok miktar� d��ar�dan girilen iki de�er aras�nda olan,
�r�n fiyat� d��ar�dan girilen iki de�er aras�nda olan,
tedarik�i firma ad� d��ar�dan girilen de�eri i�eren �r�nleri,
�r�n Ad�, Fiyat�, %10 Kdvli Fiyat�, Stok Miktar� ve Tedarik�i firma ad� �eklinde listeleyen bir sp yazal�m.
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

--Belirli bir tarihden (y�l) sonra sipari� veren m��terilerin detaylar�n� getiren ve ayn� zamanda sipari�lerin toplam tutarlar�n� hesaplayan bir sp yaz�n�z. (CustomerID,CompanyName,OrderID,OrderDate,Total)

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