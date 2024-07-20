/*
Istanbul Eðitim Akadem DB Tasarýmý
Tablolar:
BLOG
	-BlogCategories
	-BlogPosts
	-BlogTags
	-Bridge-BlogTags_BlogPosts
*/

Create Database IstEducationDB
use IstEducationDB

Create Table BlogCategories
(
BlogCatID uniqueidentifier primary key, --select NEWID()
[Name] nvarchar(150),
[Description] nvarchar(300),
SeoUrl nvarchar(250)
)

Create Table BlogPosts(
PostID uniqueidentifier primary key,
Title nvarchar(150),
SeoUrl nvarchar(200),
SummaryContent nvarchar(max),
Content nvarchar(max),
FeaturedImageUrl varchar(max),
IsHighLight bit,
IsActive bit,
BlogCatID uniqueidentifier,
FOREIGN KEY(BlogCatID) REFERENCES BlogCategories(BlogCatID)
)

Create Table BlogTags(
TagID uniqueidentifier primary key,
TagName nvarchar(80),
TagDescription nvarchar(250)
)

Create Table Bridge_BlogTags_BlogPosts
(
Id uniqueidentifier primary key,
TagID uniqueidentifier,
PostID uniqueidentifier,
Foreign key (TagID) references BlogTags(TagID),
Foreign key (PostID) references BlogPosts(PostID),
)

/*
EDUCATION
	EducationCategories
	Education
	EducationTags
	Bridge_EducationTags_Education
	EducationGains
	EducationParts
	EducationComments
	EducationMediaItems
*/