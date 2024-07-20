--STRING FONKS�YONLARI
Select LTRIM('        Yetenek Ba�ak�ehir')
Select RTRIM('Yetenek Ba�ak�ehir       ')
Select UPPER('Yetenek Ba�ak�ehir')
Select LOWER('YETENEK BA�AK�EH�R')

Select LEFT('Yetenek Ba�ak�ehir',4)
Select RIGHT('Yetenek Ba�ak�ehir',4)
Select SUBSTRING('Yetenek Ba�ak�ehir',2,5)

Select CustomerID,CompanyName,SUBSTRING(CompanyName,1,4) Kod from Customers

Select REVERSE('Yetenek Ba�ak�ehir')
Select REPLACE('Yetenek Ba�ak�ehir','Yetenek','Kariyer')
Select REPLACE('Yetenek Ba�ak�ehir',' ','')

--MATH FONKS�YONLARI
Select COS(50)
Select TAN(50)
Select ABS(-79)
Select SQRT(49)
Select POWER(2,6)

Select MIN(UnitPrice)
from Products

Select MAX(UnitPrice)
from Products

Select AVG(UnitPrice)
from Products

Select SUM(UnitsInStock)
from Products

select * from Products

--DATETIME FONKSIYONLARI
Select GETDATE()
Select YEAR(GETDATE())
Select MONTH(GETDATE())
Select DAY(GETDATE())

Select DATENAME(DW,'06.24.2024') --dayofweek
Select DATENAME(M,'06.24.2024') --month
Select DATENAME(D,'06.24.2024') --day

Select DATEPART(HOUR,GETDATE()) AS SAAT
Select DATEPART(MINUTE,GETDATE()) AS DAK�KA

Select FORMAT(GETDATE(),'HH:mm:ss')

Select DATEDIFF(Year,'06.24.1985',GetDate())
Select DATEDIFF(Month,'06.24.1985',GetDate())
Select DATEDIFF(Day,'06.24.1985',GetDate())

Select DATEADD(DAY,15,GETDATE())
Select DATEADD(MINUTE,-35,GETDATE())

--15 hafta sonra bug�n y�l�n ka��nc� g�n�d�r?
Select DATEPART(DAYOFYEAR,DATEADD(WEEK,15,GETDATE()))
Select DATEADD(WEEK,15,GETDATE())

--�al��anlar i�in n.davolio@istanbulegitimakademi.com format�nda email adresleri olu�turulacakt�r. Ad Soyad ve Email Adresi �eklinde listeleyiniz.

Select FirstName+' '+LastName AdSoyad,
LOWER(LEFT(FirstName,1)+'.'+LastName+'@istanbulegitimakademi.com') as Email
from Employees

--�al��anlar�n Ad Soyad ve Ya�lar�n� listeleyiniz.
Select 
FirstName,
LastName,
DATEDIFF(Year,BirthDate,getdate()) Yas
from Employees

--Ortalama fiyattan pahal� olan �r�nler hangileridir.
Select *
from Products 
where UnitPrice>(Select Avg(UnitPrice) from Products)

--SQL AGGREGATE FUNCTIONS (Toplam Fonksiyonlar�)
--AVG, MIN, MAX, SUM, COUNT

--COUNT
--Tablolarda bulunan kay�t say�s�n� saymak i�in kullan�lan fonksiyondur.

--Toplam ka� adet sipari�imiz bulunmaktad�r. 
Select COUNT(*)
from Orders

--Toplam ka� adet �r�n�m bulunmaktad�r.
Select Count(*) UrunSayisi from Products

Select Count(OrderID)
from Orders --830 sat�r kay�t geldi.

--Null olmayan alanlar� sayar.
select Count(ShipRegion) from Orders  --323 sat�r kay�t geldi.

select Count(*) from Orders where ShipRegion is null	

--Herhangi bir sutunda bulunan benzersiz kay�tlar� saymak i�in:
--830 adet sipari� toplam 21 farkl� �lkeye g�ndelirecektir.
Select Count(Distinct ShipCountry) from Orders

--5 numaral� �al��an�m�z ka� adet sipari�te g�rev alm��t�r.
Select Count(*)
from Orders
where EmployeeID=5

--2 numaral� kategoriye ait olan toplam ka� adet �r�n vard�r.

Select Count(*)
from Products
where CategoryID=2

--T�m kategorilerimize ait ka� adet �r�n bulunmaktad�r?
Select CategoryID,Count(*) UrunAdedi
from Products
group by CategoryID

select * from Products order by CategoryID

--T�m �reticilerimize ait toplam ka� adet �r�n�m�z bulunmaktad�r.
Select SupplierID,Count(*) UrunAdedi
from Products
group by SupplierID

--T�m �reticilerimize ait stoklar�m�zda toplam ka� adet �r�n�m�z bulunmaktad�r.
Select SupplierID,Sum(UnitsInStock) UrunStokAdedi
from Products
group by SupplierID

--ID'si FRANK olan m��terimize ait ka� adet sipari� vard�r?

select CustomerID,Count(*) [Sipari� Say�s�]
from Orders
where CustomerID='FRANK'
group by CustomerID

select * from Products

--10248 numaral� sipari�imizin i�erisinde toplam ka� farkl� �r�n al�nm��t�r?
Select OrderID,Count(ProductID)
from [Order Details]
where OrderID=10248
group by OrderID

--10248 numaral� sipari�imizin toplam tutar� nedir?
Select OrderID,ROUND(SUM((UnitPrice*Quantity)*(1-Discount)),2) ToplamTutar
from [Order Details]
where OrderID=10250
group by OrderID

select * from [Order Details]

--Kargo �irketlerinin toplam ka� adet g�nderisi vard�r.

select EmployeeID,Count(*) from Orders
group by EmployeeID

--HAVING
--Gruplama yapt�ktan sonra elde edilen liste �zerinde herhangi bir kriter (filtre) uygulamak istersek having kullan�l�r.
--Where gruplamadan �nce �al���r ve filtreleme yapar.
--Having gruplanm�� datay� filtreler.

--T�m sipari�lerimiz i�erisinde fatura toplam� 10.000$'�n �zerinde olan sipari�ler hangileridir?

Select OrderID,ROUND(SUM((UnitPrice*Quantity)*(1-Discount)),2) ToplamTutar
from [Order Details]
GROUP BY OrderID
HAVING ROUND(SUM((UnitPrice*Quantity)*(1-Discount)),2)>10000

--20.000 $ dan fazla �deme yap�lan kargo sirketleri hangileridir.

Select ShipVia,Sum(Freight) [Toplam Kargo �creti]
from Orders
group by ShipVia
Having Sum(Freight) > 20000

--SQL JOIN
/*
Join ile sql �zerinde birden fazla tabloyu birbirine ba�layabiliriz. Bunun i�in INNER JOIN ve ON ifadeleri kullan�l�r.

Tablolar genelde PRIMARY KEY  ve FOREIGN KEY �zerinden ba�lan�r. Ancak gerekti�inde herhangi bir alan da bu i�lem i�in kullan�labilir. Bunun i�in bu alanlar�n veri tipleri ayn� olmal�d�r.

INNER JOIN, OUTER JOIN (left, right), CROSS, UNION
*/

--�r�nlerin isimlerini ve kategori isimlerini listeleyiniz.
select ProductName,CategoryName
from Products
INNER JOIN Categories
ON Categories.CategoryID=Products.CategoryID

--Tablolara etiket tan�mlayarak daha k�sa yazabiliriz.
select ProductName,CategoryName
from Products p
INNER JOIN Categories c
ON c.CategoryID=p.CategoryID

--Tabloda CategoryID isimli 2 farkl� sutun oldu�undan p.CategoryID �eklinde belirtildi.
select p.CategoryID,ProductName,CategoryName
from Products p
INNER JOIN Categories c
ON c.CategoryID=p.CategoryID

--�al��anlar�n yapm�� olduklar� sipari� adetlerini, �al��an Ad� Soyad�, Sipari� Adedi �eklinde listeleyiniz.
Select FirstName+' '+LastName [Ad Soyad],Count(*) [Sipari� Adedi]
from Orders o
inner join Employees e
on e.EmployeeID=o.EmployeeID
group by FirstName+' '+LastName

--TOFU isimli �r�n�n al�nd��� t�m sipari� numaralar�n� listeleyiniz.
Select OrderID
from [Order Details] od
inner join Products p
on p.ProductID=od.ProductID
where ProductName='Tofu'

--T�m �r�nlerimizi �r�n Ad�, Kategori Ad� ve Tedarik�i Ad� �eklinde listeleyiniz.
Select ProductName,CategoryName,CompanyName from 
Products p
inner join Categories c
on p.CategoryID=c.CategoryID
inner join Suppliers s
on s.SupplierID=p.SupplierID

--Federal Shipping ile tan��m��, Nancy �zerine kay�tl� olan sipari�leri �al��an Ad� Soyad�, Siparis No, Siparis Tarihi ve Kargo �creti �eklinde g�r�nt�leyiniz.

Select *
from Orders o
inner join Employees emp
on emp.EmployeeID=o.EmployeeID
inner join Shippers sh
on sh.ShipperID=o.ShipVia
where sh.CompanyName='Federal Shipping' and FirstName='Nancy'


--Herbir �r�n�m�zden toplam ka� adet sat�lm��t�r ve �r�n bazl� ciromuz ne kadard�r?
--ProductName, CategoryName,Toplam Sat�lan Adet, Toplam Ciro

Select ProductName,
CategoryName,
SUM(Quantity) [Toplam Sat�lan Adet],
ROUND(SUM((od.UnitPrice*Quantity)*(1-Discount)),2) [�r�n Bazl� Ciro]
from [Order Details] od
inner join Products p
on p.ProductID=od.ProductID
inner join Categories c
on c.CategoryID=p.CategoryID
group by ProductName,CategoryName
order by [�r�n Bazl� Ciro] desc

