USE [Apress_DupDetection]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_RemoveNonNumeric]    Script Date: 9/28/2018 10:08:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Function [dbo].[fn_RemoveNonNumeric](@strText nVARCHAR(1000))
RETURNS nVARCHAR(1000)
AS
BEGIN
    WHILE PATINDEX('%[^0-9]%', @strText) > 0
    BEGIN
        SET @strText = STUFF(@strText, PATINDEX('%[^0-9]%', @strText), 1, '')
    END
    RETURN coalesce(@strText,'')
END
GO
/****** Object:  UserDefinedFunction [dbo].[fn_StripSpaces]    Script Date: 9/28/2018 10:08:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Function [dbo].[fn_StripSpaces](@string nvarChar(Max)) 
returns nvarChar(max)
as
begin
	return coalesce(replace(@string,' ',''),'')

end
GO
/****** Object:  Table [dbo].[SF_Contacts]    Script Date: 9/28/2018 10:08:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SF_Contacts](
	[Id] [nvarchar](18) NULL,
	[FirstName] [nvarchar](40) NULL,
	[Email] [nvarchar](80) NULL,
	[LastName] [nvarchar](80) NULL,
	[MobilePhone] [nvarchar](40) NULL,
	[OtherPhone] [nvarchar](40) NULL,
	[Phone] [nvarchar](40) NULL,
	[HomePhone] [nvarchar](40) NULL,
	[Fax] [nvarchar](40) NULL,
	[MailingCity] [nvarchar](40) NULL,
	[MailingState] [nvarchar](80) NULL,
	[MailingStreet] [nvarchar](255) NULL,
	[MailingPostalCode] [nvarchar](20) NULL,
	[OtherCity] [nvarchar](40) NULL,
	[OtherCountry] [nvarchar](80) NULL,
	[OtherState] [nvarchar](80) NULL,
	[OtherStreet] [nvarchar](255) NULL,
	[OtherPostalCode] [nvarchar](20) NULL,
	[Website__c] [nvarchar](255) NULL,
	[AccountId] [nvarchar](18) NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Contact_DupKeys]    Script Date: 9/28/2018 10:08:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[Contact_DupKeys] as 
Select
    c.id as CONTACTID
    ,'Email' as KeyName
    ,dbo.fn_StripSpaces(c.EMAIL) as KeyValue
from SF_Contacts c
where dbo.fn_StripSpaces(c.EMAIL) <>''
union 
select 
     c.id as CONTACTID
    ,'First+Last' as KeyName
    ,dbo.fn_StripSpaces(c.FIRSTNAME+c.lastname) as KeyValue
from SF_Contacts c
where dbo.fn_StripSpaces(c.FIRSTNAME+c.lastname) <>''
union 
select 
     c.id as CONTACTID
    ,'MobilePhone' as KeyName
    ,dbo.fn_RemoveNonNumeric(c.MobilePhone) as KeyValue
from SF_Contacts c
where dbo.fn_RemoveNonNumeric(c.MobilePhone) is not null
and dbo.fn_RemoveNonNumeric(c.MobilePhone)<>''
union
select 
     c.id as CONTACTID
    ,'Phone' as KeyName
    ,dbo.fn_RemoveNonNumeric(c.Phone) as KeyValue
from SF_Contacts c
where dbo.fn_RemoveNonNumeric(c.Phone) is not null
and dbo.fn_RemoveNonNumeric(c.Phone)<>''
union
select 
     c.id as CONTACTID
    ,'HomePhone' as KeyName
    ,dbo.fn_RemoveNonNumeric(c.HomePhone) as KeyValue
from SF_Contacts c
where dbo.fn_RemoveNonNumeric(c.HomePhone) is not null
and dbo.fn_RemoveNonNumeric(c.HomePhone)<>''
union
select 
     c.id as CONTACTID
    ,'Fax' as KeyName
    ,dbo.fn_RemoveNonNumeric(c.Fax) as KeyValue
from SF_Contacts c
where dbo.fn_RemoveNonNumeric(c.Fax) is not null
and dbo.fn_RemoveNonNumeric(c.Fax)<>''
union
select 
     c.id as CONTACTID
    ,'OtherPhone' as KeyName
    ,dbo.fn_StripSpaces(c.lastname)+dbo.fn_RemoveNonNumeric(c.OtherPhone) as KeyValue
from SF_Contacts c
where dbo.fn_RemoveNonNumeric(c.OtherPhone) is not null
and dbo.fn_RemoveNonNumeric(c.OtherPhone)<>''
union
select 
     c.id as CONTACTID
    ,'Last+Phone' as KeyName
    ,dbo.fn_StripSpaces(c.lastname)+dbo.fn_RemoveNonNumeric(c.Phone) as KeyValue
from SF_Contacts c
where dbo.fn_RemoveNonNumeric(c.Phone) is not null
and dbo.fn_RemoveNonNumeric(c.Phone)<>''
union
select 
     c.id as CONTACTID
    ,'Last+HomePhone' as KeyName
    ,dbo.fn_StripSpaces(c.lastname)+dbo.fn_RemoveNonNumeric(c.HomePhone) as KeyValue
from SF_Contacts c
where dbo.fn_RemoveNonNumeric(c.HomePhone) is not null
and dbo.fn_RemoveNonNumeric(c.HomePhone)<>''
union
select 
     c.id as CONTACTID
    ,'Last+Fax' as KeyName
    ,dbo.fn_StripSpaces(c.lastname)+dbo.fn_RemoveNonNumeric(c.Fax) as KeyValue
from SF_Contacts c
where dbo.fn_RemoveNonNumeric(c.Fax) is not null
and dbo.fn_RemoveNonNumeric(c.Fax)<>''
union
select 
     c.id as CONTACTID
    ,'Last+OtherPhone' as KeyName
    , dbo.fn_StripSpaces(c.lastname)+dbo.fn_RemoveNonNumeric(c.OtherPhone) as KeyValue
from SF_Contacts c
where dbo.fn_RemoveNonNumeric(c.OtherPhone) is not null
and dbo.fn_RemoveNonNumeric(c.OtherPhone)<>''

GO
/****** Object:  Table [dbo].[SF_Leads]    Script Date: 9/28/2018 10:08:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SF_Leads](
	[Id] [nvarchar](18) NULL,
	[Fax] [nvarchar](40) NULL,
	[FirstName] [nvarchar](40) NULL,
	[City] [nvarchar](40) NULL,
	[State] [nvarchar](80) NULL,
	[Street] [nvarchar](255) NULL,
	[PostalCode] [nvarchar](20) NULL,
	[Phone] [nvarchar](40) NULL,
	[LastName] [nvarchar](80) NULL,
	[MobilePhone] [nvarchar](40) NULL,
	[Company] [nvarchar](255) NULL,
	[Email] [nvarchar](80) NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Lead_DupKeys]    Script Date: 9/28/2018 10:08:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View [dbo].[Lead_DupKeys] as 
Select
     c.id as LeadID
     ,'Email' as KeyName
     ,dbo.fn_StripSpaces(c.EMAIL) as KeyValue
from SF_Leads c
where dbo.fn_StripSpaces(c.EMAIL) <>''
union 
select 
     c.id as LeadID
     ,'First+Last' as KeyName
     ,dbo.fn_StripSpaces(c.FIRSTNAME+c.lastname) as KeyValue
from SF_Leads c
where dbo.fn_StripSpaces(c.FIRSTNAME+c.lastname) <>''
union 
select 
     c.id as LeadID
     ,'MobilePhone' as KeyName
     ,dbo.fn_RemoveNonNumeric(c.MobilePhone) as KeyValue
from SF_Leads c
where dbo.fn_RemoveNonNumeric(c.MobilePhone) is not null
and dbo.fn_RemoveNonNumeric(c.MobilePhone)<>''
union
select 
     c.id as LeadID
     ,'Phone' as KeyName
     ,dbo.fn_RemoveNonNumeric(c.Phone) as KeyValue
from SF_Leads c
where dbo.fn_RemoveNonNumeric(c.Phone) is not null
and dbo.fn_RemoveNonNumeric(c.Phone)<>''
union
select 
     c.id as LeadID
     ,'Fax' as KeyName
     ,dbo.fn_RemoveNonNumeric(c.Fax) as KeyValue
from SF_Leads c
where dbo.fn_RemoveNonNumeric(c.Fax) is not null
and dbo.fn_RemoveNonNumeric(c.Fax)<>''

GO
/****** Object:  View [dbo].[Contact_Dup_Report]    Script Date: 9/28/2018 10:08:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[Contact_Dup_Report] as
Select top 100 PERCENT --- Need top for order by in view
    cd.ContactId
    ,cd.KeyName
    ,cd.KeyValue
--All the fields on SF_Conatct
	,c.[AccountId]
	,c.[FirstName]
	,c.[LastName]
	,c.[Email] 
	,c.[MobilePhone] 
	,c.[OtherPhone]
	,c.[Phone] 
	,c.[HomePhone] 
	,c.[Fax] 
	,c.[MailingCity]
	,c.[MailingState]
	,c.[MailingStreet] 
	,c.[MailingPostalCode]
	,c.[OtherCity]
	,c.[OtherCountry]
	,c.[OtherState]
	,c.[OtherStreet]
	,c.[OtherPostalCode]
	,c.[Website__c]
from SF_Contacts c
join [dbo].[Contact_DupKeys] cd on cd.ContactID=c.ID
join (
        Select 
            KeyValue
        from Contact_DupKeys cdk
        group by KeyValue 
        having count(distinct contactid)>1
    ) dr on dr.KeyValue=cd.KeyValue
order by cd.KeyValue,c.id

GO
/****** Object:  View [dbo].[Contact_Lead_Dup_Report]    Script Date: 9/28/2018 10:08:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[Contact_Lead_Dup_Report] as
Select distinct top 100 PERCENT --- Need top for order by in view
	Ld.LeadID
	,cd.CONTACTID
	---- All the Contact Fields
	,c.[FirstName] as [Contact_FirstName]
	,c.[LastName] as [Contact_LastName]
	,c.[Email] as [Contact_Email]
	,c.[MobilePhone] as [Contact_MobilePhone]
	,c.[OtherPhone] as [Contact_OtherPhone]
	,c.[Phone] as [Contact_Phone]
	,c.[HomePhone] as [Contact_HomePhone]
	,c.[Fax] as [Contact_Fax]
	,c.[MailingCity] as [Contact_MailingCity]
	,c.[MailingState] as [Contact_MailingState]
	,c.[MailingStreet] as [Contact_MailingStreet]
	,c.[MailingPostalCode] as [Contact_MailingPostalCode]
	,c.[OtherCity] as [Contact_OtherCity]
	,c.[OtherCountry] as [Contact_OtherCountry]
	,c.[OtherState] as [Contact_OtherState]
	,c.[OtherStreet] as [Contact_OtherStreet]
	,c.[OtherPostalCode] as [Contact_OtherPostalCode]
	,c.[Website__c] as [Contact_Website__c]
	,c.[AccountId] as [Contact_AccountId]
	---- All the fields on SF_Leads
	,l.[FirstName] as [Lead_FirstName]
	,l.[LastName] as [Lead_LastName]
	,l.[Company] as [Lead_Company]
	,l.[Email] as [Lead_Email]
	,l.[Phone] as [Lead_Phone]
	,l.[MobilePhone] as [Lead_MobilePhone]
	,l.[Fax] as [Lead_Fax]
	,l.[Street] as [Lead_Street]
	,l.[City] as [Lead_City]
	,l.[State] as [Lead_State]
	,l.[PostalCode] as [Lead_PostalCode]
from  dbo.Lead_DupKeys ld
Join dbo.Contact_DupKeys cd on cd.KeyValue=ld.KeyValue
join dbo.SF_Leads l on l.id=ld.LeadID
join dbo.SF_Contacts c on c.id=cd.CONTACTID
GO
/****** Object:  View [dbo].[Lead_Dup_Report]    Script Date: 9/28/2018 10:08:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[Lead_Dup_Report] as
Select top 100 PERCENT --- Need top for order by in view
    ld.LeadId
    ,ld.KeyName
    ,ld.KeyValue
	---- All the fields on SF_Leads
	,l.[FirstName]
	,l.[LastName]
	,l.[Company]
	,l.[Email] 
	,l.[Phone]
	,l.[MobilePhone]
	,l.[Fax]
	,l.[Street]
	,l.[City]
	,l.[State]
	,l.[PostalCode]
from SF_Leads l
join [dbo].[Lead_DupKeys] ld on ld.LeadID=l.ID
join (
        Select 
            KeyValue
        from Lead_DupKeys ldk
        group by KeyValue 
        having count(distinct leadid)>1
    ) dr on dr.KeyValue=ld.KeyValue
order by ld.KeyValue,l.id

GO
