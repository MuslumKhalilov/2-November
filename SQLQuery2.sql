create database Task

use Task

create table Users(
[Id] int primary key identity,
[Name] varchar (50),
[Surname] varchar (50),
[Username] varchar (50),
[Password] varchar (50),
[Gender] varchar (50)
)

create table Artists(
[Id] int primary key identity,
[Name] varchar (50),
[Surname] varchar (50),
[Birthday] date,
[Gender] varchar (50)
)

create table Categories(
[Id] int primary key identity,
[Name] varchar (50)
)

create table Musics(
[Id] int primary key identity,
[Name] varchar (50),
[Duration] int,
[ArtistId] int references Artists(Id),
[CategoryId] int references Categories(Id)
)
 create table Playlist(
 [Id] int primary key identity,
 [UserId] int references Users(Id),
 [MusicId] int references Musics(Id)
 )

 create view GetMusicInfo as 
 select m.Name as [Music Name], m.Duration as [Music Duration], c.Name as [Category Name],a.Name as [Artist Name] from Musics as m 
 join Categories as c
 on c.Id=m.CategoryId
 join Artists as a
 on a.Id=m.ArtistId

 create procedure usp_CreateMusic(
 @name varchar(50),@duration int,@artistId int, @categoryId int
 ) 
 as
 insert into Musics values(@name,@duration,@artistId,@categoryId)

 create procedure usp_CreateUser(
 @name varchar (50),@surname varchar (50),@username varchar (50),@password varchar (50),@gender varchar (50)
 )
 as
 insert into Users values(@name,@surname,@username,@password,@gender)

 create procedure usp_CreateCategory(
 @name varchar(50)
 )
 as
 insert into Categories values(@name)

 insert into Artists values
 ('Avril','Lavigne','1984-09-27','Female'),
 ('Taylor','Swift','1989-12-13','Female')

 exec usp_CreateCategory 'Rock'
  exec usp_CreateCategory 'Pop'

 exec usp_CreateMusic 'Complicated',194,3,3
 exec usp_CreateMusic 'Trouble',222,4,4

 exec usp_CreateUser 'name1','surname1','username1','password1','gender1'
 exec usp_CreateUser 'name2','surname2','username2','password2','gender2'

 insert into Playlist values
 (3,7),
 (4,6)
 
 alter table Musics
 add IsDeleted bit not null default (0)

 create trigger trg_DeleteMusic
 on Musics
 instead of delete
 as
 declare @result bit
 declare @Id int
 select @result=IsDeleted,@Id=Id from deleted
 if (@result=0)
 begin
 update Musics set IsDeleted=1 where @Id=Id
 end
 else
 begin
 delete from Musics where @Id=Id
 end

 create function GetArtistsCount (@Id int)
 returns int 
 begin
 declare @ArtistCount int
 select @ArtistCount=count(Artists.Name) from Users
  join Playlist on Users.Id = Playlist.UserID
  join Musics on Playlist.MusicID = Musics.Id
  join Artists on Musics.ArtistID = Artists.Id
  where @Id=UserId
  return @ArtistCount
 end

 select dbo.GetArtistsCount (3) as ArtistCount
 





 
 