--Ürün kategorilerine göre adet bazlý satýþlarý listeleyelim.

Select c.CategoryName,Sum(Quantity)
from [Order Details] od
inner join Products p
on p.ProductID=od.ProductID
inner join Categories c
on c.CategoryID=p.CategoryID
group by c.CategoryName

--Çalýþanlarým ürün bazýnda ne kadarlýk satýþ yapmýþlar. (Çalýþan Adý, Ürün Adý, Adet, Ciro)
--Top N kaydýn getirmesi

Select top 5 FirstName+' '+LastName AdSoyad,ProductName,Sum(Quantity) Adet,
Round(Sum((od.UnitPrice*Quantity)*(1-Discount)),2) Ciro
from [Order Details] od
inner join Orders o
on o.OrderID=od.OrderID
inner join Employees emp
on emp. EmployeeID=o.EmployeeID
inner join Products p
on p.ProductID=od.ProductID
group by FirstName+' '+LastName,ProductName
order by Ciro desc

--OUTER JOIN (Left Outer Join, Right Outer Join)
--Left ve Right Outer Join 

Select EmployeeID from Employees
select Distinct(EmployeeID) from Orders

Select * from Employees where EmployeeID 
not in(Select EmployeeID from Orders)

--830 satýr kayýt geldi. 
Select *
from Employees emp
inner join Orders o
on o.EmployeeID=emp.EmployeeID

--831 satýr kayýt geldi.
--Left Outer Join: eþleþmenin sol tarafýnda kalan tablodaki tüm satýrlarý getirir.
Select *
from Employees emp left join Orders o
on o.EmployeeID=emp.EmployeeID

--831 satýr kayýt geldi.
--Right Outer Join: eþleþmenin sað tarafýnda kalan tablodaki tüm satýrlarý getirir.
Select *
from Orders o right join Employees emp
on o.EmployeeID=emp.EmployeeID

--CROSS JOIN
--Üreticilerimizin çalýþabileceði tüm kargo sirketi alternatiflerini listeyiniz.
--Shippers > 3 adet
--Suppliers > 29 adet
--Sonuç: 87 satýr kayýt üretildi.
Select * from Shippers
CROSS JOIN Suppliers

--UNION
--Ýki veya daha fazla select sorgusunun sonuçlarýný tek bir sorguda birleþtirir.
--Görüntülenecek clon satýrlar ayný veri türünde, ayný sayýda ve ayný düzende olmalýdýr.

Select Lower(REPLACE(Left(EmailName,5),' ','')+'@istanbulegitimakademi.com') from
(Select CompanyName EmailName,City from Customers
UNION
Select FirstName+' '+LastName,City from Employees
UNION
Select CompanyName,'-' from Shippers
UNION
Select CompanyName,City from Suppliers) tablo

--DDL KOMUTLARI
--Create, Alter, Drop

/*
char(10)		"Ali"       10 byte
varchar(10)		"Ali"		3 byte
nvarchar(10)	"Ali"		3 byte bu tüm alfabelerin harflerini ve karakter setlerini içeren UNICODE karakter setinde bir deðiþken tanýmlamýmýzý saðlar.
*/

Create Database KursDB 
use KursDB

Create Table Egitmen(
EgitmenID int primary key identity(1,1),
Adi nvarchar(50),
Soyadi nvarchar(50),
Email nvarchar(50),
UzmanlikAlani nvarchar(100)
)

Create Table Kurs(
KursID int primary key identity(1,1),
KursAdi nvarchar(120) not null,
BaslangicTarihi date,
BitisTarihi date,
EgitmenID int
)

ALTER TABLE Kurs
ADD CONSTRAINT FK_Kurs_Egitmen 
FOREIGN KEY(EgitmenID) 
REFERENCES Egitmen(EgitmenID)

Create Table Ders(
DersID int primary key identity(1,1),
DersAdi nvarchar(200) not null,
KursID int,
Foreign key(KursID) references Kurs(KursID)
)

Create Table Ogrenci(
OgrenciID int primary key identity(1,1),
Adi nvarchar(50) not null,
Soyadi nvarchar(50) not null,
DogumTarihi date,
TCKimlik char(11) not null
)

 Create Table Sinav(
 SinavID int primary key identity(1,1),
 SinavAdi nvarchar(100),
 SinavTarihi date
 )

 --Bir öðrenci birden çok kursa kayýt olabilir.
 --Bir kurs içerisinde birden çok öðrenci yer alabilir.
 --Bu nedenle Ogrenci ve Kurs tablolarý arasýna bir ara tablo(Kayit) yapýyoruz.

 Create Table Kayit(
 KayitID int primary key identity(1,1),
 KayitTarihi date,
 KursID int,
 OgrenciID int,
 foreign key(KursID) references Kurs(KursID),
 foreign key(OgrenciID) references Ogrenci(OgrenciID)
 )

 --Composite Key
 --SQL'de bileþik anahtar (composite key), birden fazla sütunun bir araya gelerek oluþturduðu birincil anahtar veya benzersiz anahtar anlamýna gelir. Bileþik anahtar, tek bir sütunun benzersizliði saðlamak için yeterli olmadýðý durumlarda kullanýlýr. 

 Create Table SinavSonuc(
 OgrenciID int,
 SinavID int,
 Notu tinyint,
 primary key(OgrenciID,SinavID)
 )

 Alter table SinavSonuc
 add constraint FK_SinavSonuc_Ogrenci
 foreign key(OgrenciID) references Ogrenci(OgrenciID)

 Alter table SinavSonuc
 add constraint FK_SinavSonuc_Sinav
 foreign key(SinavID) references Sinav(SinavID)