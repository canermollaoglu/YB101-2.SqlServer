/*
SQL NEDÝR? (Structured Query Language)
Sql bir veritabaný sorgulama dilidir. Sql ile veritabanýna yeni tablolar, kayýtlar ekleyip silebilir, var olanlar üzerinde düzenlemeler ve filtrelemeler yapabiliriz.

Sql ile Oracle, db2, Sybase, Informix, Microsoft Sql Server, Ms Access gibi veritabaný yönetim sistemlerinde çalýþabiliriz. Sql standart bir veritabaný sorgulama dilidir ve bütün geliþmiþ veritabaný uygulamalarýnda kullanýlýr.

T-SQL (Transact Sql)		PL-SQL

Sql'de kullanýlan komutlar 3 ana baþlýkta toplanýr:

DDL (Data Definition Language)
Create, Alter , Drop

DML (Data Manipulation Language)
Select, Insert, Update, Delete

DCL (Data Control Language)
Grant, Deny, Revoke

Sql Server bir RDMBS'dir. (Relational DataBase Management System)
*/

--Select Ifadesi
--tüm sutunlarý getirir

USE Northwnd

SELECT * FROM Employees
SELECT * FROM Customers

--belirli sutunlari getirme

Select CustomerID,CompanyName,City,Country
from Customers

--Filtreleme (WHERE)
Select *
from Customers
where Country='Canada'

--Birim fiyatý 40 dolara eþit ya da fazla olan ürünleri listeleyiniz.
Select *
from Products
where UnitPrice>=40


--Hangi sipariþlerin içerisinde 11 numaralý urunden satýn alýnmýþtýr.
Select *
from [Order Details]
where ProductID=11

--Sutun Ýsimlendirme (as)
Select FirstName+' '+LastName [Ad Soyad],EmployeeID
from Employees

--1 numaralý tedarikciye ait olan ürünlerimiz hangileridir.

Select *
from Products
where SupplierID=1

--AND, OR, NOT Operatörleri
--5 numaralý personelin 1998 yýlýndan itibaren aldýðý sipariþlerin listeleyelim.
Select *
from Orders
where EmployeeID=5 and OrderDate>'1998'

--Berlindeki ve Amerikadaki üreticileri listelemek istiyoruz.

Select *
from Suppliers
where City='Berlin' or Country='USA'

--1 ve 2 nolu üreticilerin 20$ dan pahalý olan ürünlerini listeleyiniz.
Select *
from Products
where UnitPrice>20 and (SupplierID=1 or SupplierID=2)

--Sipariþleri EmployeeID'ye göre sýralayýnýz

Select *
from Orders
order by EmployeeID asc

Select *
from Orders
order by EmployeeID desc

--Stok miktarý 50 den fazla olan ürünleri listeleyelim.

Select *
from Products
where UnitsInStock>50
order by UnitsInStock desc

--Between .... and
--iki deðer aralýðýndaki tüm kayýtlarý getirir

Select * from Products
where UnitPrice between 35 and 65

Select *
from Customers
where CustomerID between 'ALFKI' and 'CACTU'

--Like ifadesi
--Sutundaki deðerlerin joker karakterler (%,[]) kullanarak oluþturduðumuz bir arama kosulu ile karþýlaþtýrýlmasýný saðlar.

Select *
from Customers
where CompanyName LIKE '%hungry%'

/*
LIKE 'K%'		: K ile baþlayan tüm kayýtlar
LIKE 'Tr%'		: Tr ile baþlayan tüm kayýtlar
LIKE ' en'		: Toplam 3 karakter olan ve son iki harfi en olan tüm kayýtlar
LIKE '[CK]%'	: C veya K ile baþlayan tüm kayýtlar
LIKE '[s-v]ing'	: ing ile biten ilk harfi s ile ve arasýnda olan dört harfli tüm						kayýtlar.

*/

--Bir listedeki elemanlarýn aranmasý
--Japonya ve Italyadaki üreticileri listeleyiniz.
Select *
from Suppliers
where Country='Japan' or Country='Italy'

Select *
from Suppliers 
where Country IN ('Japan','Italy')

--Japonya ve Italyada olmayan üreticileri listeleyiniz.
Select *
from Suppliers 
where Country NOT IN ('Japan','Italy')

--Boþ Deðerlerin Görüntülenmesi (NULL)
--Herhangi bir alana bir deðer girilmezse ve alan için herhangi bir varsayýlan deðer yoksa bu alanýn deðeri NULL olur. Null deðeri boþluk '' ve 0(sýfýr) dan farklýdýr.
--IS NULL

Select *
from Suppliers
where Region IS NULL

Select *
from Suppliers
where Region IS NOT NULL

--Hangi ülkelerde bulunan üreticiler ile çalýþýyoruz.
--Sutundaki benzersiz kayýtlarý getirir.
Select distinct Country
from Suppliers

--birden fazla alan için sýralama yapabiliriz. 

Select *
from Products
order by CategoryID desc, UnitPrice asc

Select *
from Products
order by 4 desc, 6 asc

Select * from Orders
Select * from [Order Details]

--Adres bilgisi içerisinde St. geçen tedarikçileri listeleyiniz

select *
from Suppliers
where Address like '%St.%'


--VINET id li müþterinin yapmýþ olduðu tüm siparisleri listeleyiniz.
select *
from Orders
where CustomerID='VINET'

--Londra veya Tokyo da bulunan tedarikçilerden region bilgisi null olanlarý listeleyiniz.
select *
from Suppliers
where City in ('London','Tokyo') and region is null

--Birim fiyatý 10 dolar ile 45 dolar arasýnda olan ürünlerden kategorisi 2 olanlarý listeleyiniz.

select *
from Products	
where CategoryID=2 and UnitPrice between 10 and 45


--Kategori idsi 5 olan, Birim Fiyatý 20 ile 35 dolar arasýnda olan ve ürün adý içerisinde 'gute' kelimesi geçen ürünleri listeleyiniz.
select *
from Products
where ProductName like '%gute%' and CategoryID=5 and UnitPrice between 20 and 35

select *
from Products
where ProductName like '%[gute]%' and CategoryID=5 and UnitPrice between 20 and 35

--Matematiksel Ýþlemler

select 12+3

--Birim fiyat ile miktar çarpýlarak ürün bazlý olarak toplam maliyeti bulalým.

select OrderID,ProductID,UnitPrice,Quantity,UnitPrice*Quantity TotalCost
from [Order Details]
order by TotalCost desc

--TotalCost 15000 dolardan fazla olan sipariþleri listeleyiniz.
select OrderID,ProductID,UnitPrice,Quantity,(UnitPrice*Quantity) TotalCost
from [Order Details]
where (UnitPrice*Quantity)>15000
order by TotalCost desc





