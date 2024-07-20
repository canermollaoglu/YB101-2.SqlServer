/*
TRANSACTION MANTIÐI
Birbiri ardýna yapýlmasý gereken iþlemlerde kullanýlýr. Transaction prensip olarak ya bütün iþlemleri yapar, ya hiçbirini gerçekleþtirmez ya da bizim belirlediðimiz noktaya kadar geri döner. Ýþlemlerden bir tanesi yapýlmadýðýnda tüm iþlemleri yapýlmamýþ kabul eder. 
*/

--BankamatikDB oluþturalým
Create database BankamatikDB

use BankamatikDB

Create table Hesap(
HesapID int primary key identity(1,1),
TCKimlik char(11),
AdSoyad nvarchar(100),
Bakiye money
)

insert into Hesap values('21100212252','Ahmet Aksakal',8500)
insert into Hesap values('21199545565','Mustafa Yaçan',1500)

Select * from Hesap

--Gönderen tc, alýcý tc ve bakiye girilen bir SP yaparak iþlemi gerçekleþtirelim:

Create Proc SP_HavaleYap(
@gonderenTC char(11),
@aliciTC char(11),
@bakiye money
)
AS
BEGIN TRY
--Gönderen hesaptan parayý çekelim:
Update Hesap
Set Bakiye-=@bakiye
where TCKimlik=@gonderenTC

RAISERROR('',16,1)

--Hata Mesajý	: Oluþan hata için bir mesaj içerir.
--Hata Seviyesi : Hatanýn önem derecesi. 1 ile 25 arasýnda deðer alýr. 16 kodu kullanýcý tanýmlý hatalar için kullanýlýr.
--Durum			: Hatanýn iþletim sistemi üzerinde etkili olup olmadýðýný gösterir.

--Alýcýnýn hesabýna para yatýrýlýyor:
Update Hesap
Set Bakiye+=@bakiye
where TCKimlik=@aliciTC
END TRY
BEGIN CATCH
	print 'Beklenmedik bir hata oluþtu.'
END CATCH


Create Proc SP_TransactionHavaleYap(
@gonderenTC char(11),
@aliciTC char(11),
@bakiye money
)
AS
BEGIN TRY
	BEGIN TRANSACTION
--Gönderen hesaptan parayý çekelim:
Update Hesap
Set Bakiye-=@bakiye
where TCKimlik=@gonderenTC

RAISERROR('',16,1)

--Hata Mesajý	: Oluþan hata için bir mesaj içerir.
--Hata Seviyesi : Hatanýn önem derecesi. 1 ile 25 arasýnda deðer alýr. 16 kodu kullanýcý tanýmlý hatalar için kullanýlýr.
--Durum			: Hatanýn iþletim sistemi üzerinde etkili olup olmadýðýný gösterir.

--Alýcýnýn hesabýna para yatýrýlýyor:
Update Hesap
Set Bakiye+=@bakiye
where TCKimlik=@aliciTC
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
ROLLBACK TRANSACTION
	print 'Beklenmedik bir hata oluþtu.'
END CATCH


Create Proc SP_TransactionCommitHavaleYap(
@gonderenTC char(11),
@aliciTC char(11),
@bakiye money
)
AS
BEGIN TRY
	BEGIN TRANSACTION

	--Hesap açma iþlemi tanýmlayalým:
	Insert into Hesap values('43344545565','Kuzey Mollaoðlu',9000)

	SAVE TRANSACTION HesapAcmaIslemi

	--Gönderen hesaptan parayý çekelim:
	Update Hesap
	Set Bakiye-=@bakiye
	where TCKimlik=@gonderenTC

	RAISERROR('',16,1)

--Alýcýnýn hesabýna para yatýrýlýyor:
	Update Hesap
	Set Bakiye+=@bakiye
	where TCKimlik=@aliciTC
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
ROLLBACK TRANSACTION HesapAcmaIslemi
	print 'Beklenmedik bir hata oluþtu.'
END CATCH

select * from Hesap

exec SP_TransactionCommitHavaleYap '43344545565','21199545565',500

--Bir e-ticaret sitesi incelenerek EticaretDB oluþturulacaktýr.DDL ve DML komutlarý kullanýlarak veritabaný, tablo yapýlarý, constraint yapýlarý ve database diagram oluþturulacaktýr. Database Diagram ve Sorgu þeklinde teslim edilecektir. Deadline:  03.06.2024 Pazartesi 13:00

