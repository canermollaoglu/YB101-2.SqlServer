/*
DML KOMUTLARI
Insert, Update, Delete
*/

--Insert (Tabloya veri eklemek için kullanýlýr)
Insert into Egitmen(Adi,Soyadi,UzmanlikAlani)
values('Ahmet','Aksakal','Java')

--Ad Soyad alanlarýný boþ geçilemez yapalým:
Alter table Egitmen
alter column Adi nvarchar(50) not null

Alter table Egitmen
alter column Soyadi nvarchar(50) not null

Insert into Egitmen(Adi,Soyadi)
values ('Kuzey','Mollaoðlu')

--Tüm alanlara veri göndermek gerekir.
Insert into Egitmen 
values('Cengiz','Uzun','cuzun@gmail.com','.NET')

--Bulk Insert (Yýðýn halde insert)

/*
Insert into
select
*/

--Eðitmen tablomuzdaki bütün eðitmenlerimizi öðrencimiz olarak öðrenci tablosuna yýðýn(toplu halde) kaydedelim.

alter table Ogrenci
alter column TCKimlik char(11) null

Insert into Ogrenci(Adi,Soyadi)
Select Adi,Soyadi from Egitmen

select * from Ogrenci

--Egitmen Tablosunu Tamamen Kaldýralým:
Drop table Egitmen

--Egitmen Tablosundaki Tüm Verileri Silelim:
Truncate table Egitmen

--Egitmen Tablosuna Yeni Bir Sutun Ekleme:
Alter Table Egitmen
add TelefonNo char(11)

--Constraint Kaldýrma
Alter Table SinavSonuc
drop constraint FK_SinavSonuc_Ogrenci


--UPDATE (Güncelleme)

Update Egitmen
set Email='m.kuzey@gmail.com',UzmanlikAlani='.NET'
where EgitmenID=2

select * from Egitmen

--DELETE (Silme Ýþlemi)
Delete from Egitmen
where EgitmenID=2

--Bir eðitmen kaydedelim ve bu eðitmene ait 2 adet kurs kaydý gerçekleþtirelim.

select * from Egitmen
select * from Kurs

insert into Egitmen(Adi,Soyadi)
values('Merve','Gündüz')

--Deðiþken Tanýmlama
Declare @sonID int

Select @sonID=SCOPE_IDENTITY()

Insert into Kurs(KursAdi,BaslangicTarihi,BitisTarihi,EgitmenID)
values('Yetenek Baþaksehir Grp1','01.05.2024','01.10.2024',@sonID)

Insert into Kurs(KursAdi,BaslangicTarihi,BitisTarihi,EgitmenID)
values('Yetenek Baþaksehir Grp2','01.05.2024','01.10.2024',@sonID)

/*
WHILE (<koþul ifadesi>)
	BEGIN
	<kodlar buraya yazýlacak>
	END
*/

--Öðrenci tablomuza demo olarak 10 adet öðrenci giriþi yapalým
Declare @counter int
set @counter=1

WHILE (@counter<=10)
	BEGIN
			Insert into Ogrenci(Adi,Soyadi)
			values ('Öðrenci Adý'+CAST(@counter as varchar(max)),'Öðrenci Soyadi'+CAST(@counter as varchar(max)))
			set @counter+=1
	END

	select * from Ogrenci

