CREATE PROCEDURE [dbo].[USP_CAFINANCIALINTEGRATIONSETUP_UPDATE]
(
	@CAFINANCIALINTEGRATIONSETUPID CHAR(36),      
	@ISACTIVE                      BIT,           
	@CAFINANCIALINTEGRATIONTYPEID  INT,           
	@NAME                          NVARCHAR(100), 
	@ENABLEGL                      BIT,           
	@ENABLEAP                      BIT,           
	@ENABLEAR                      BIT,          
	@ENABLEEX                      BIT,           
	@WEBSERVICEURL                 NVARCHAR(200), 
	@USERNAME                      NVARCHAR(100), 
	@PASSWORD                      NVARCHAR(100), 
	@TENANTNAME                    NVARCHAR(100), 
	@DOMAINNAME                    NVARCHAR(100), 
	@GRANTTYPE                     NVARCHAR(100), 
	@CLIENTID                      NVARCHAR(100), 
	@CLIENTSECRET                  NVARCHAR(100), 
	@ARCODE                        NVARCHAR(100), 
	@FIELDVALUESLAYOUTVERSION      NVARCHAR(100), 
	@CHARGEINPUTFLDID              NVARCHAR(100), 
	@CHARGEINPUTFLDNAME            NVARCHAR(100), 
	@PAYMENTLAYOUTVERSION          NVARCHAR(100), 
	@WORKSTATION                   NVARCHAR(100), 
	@ISDEFAULT                     BIT,           
	@LASTCHANGEDBY                 CHAR (36),     
	@LASTCHANGEDON                 DATETIME,      
	@ROWVERSION                    INT,           
	@VENDORNUMBER					NVARCHAR(100), 
	@INCLUDENSF						BIT		
)
AS

DECLARE @OUTPUTTABLE AS TABLE([ROWVERSION]  INT)
UPDATE	[dbo].[CAFINANCIALINTEGRATIONSETUP]
SET		[ISACTIVE]      = @ISACTIVE,                      
		[CAFINANCIALINTEGRATIONTYPEID]  = @CAFINANCIALINTEGRATIONTYPEID,  
		[NAME]          = @NAME,                          
		[ENABLEGL]      = @ENABLEGL,                      
		[ENABLEAP]      = @ENABLEAP,                      
		[ENABLEAR]      = @ENABLEAR,                      
		[ENABLEEX]      = @ENABLEEX,                      
		[WEBSERVICEURL] = @WEBSERVICEURL,                 
		[USERNAME]      = @USERNAME,                      
		[PASSWORD]      = @PASSWORD,                      
		[TENANTNAME]    = @TENANTNAME,                    
		[DOMAINNAME]    = @DOMAINNAME,                    
		[GRANTTYPE]     = @GRANTTYPE,                     
		[CLIENTID]      = @CLIENTID,                      
		[CLIENTSECRET]  = @CLIENTSECRET,                  
		[ARCODE]        = @ARCODE,                        
		[FIELDVALUESLAYOUTVERSION] = @FIELDVALUESLAYOUTVERSION,      
		[CHARGEINPUTFLDID] = @CHARGEINPUTFLDID,              
		[CHARGEINPUTFLDNAME] = @CHARGEINPUTFLDNAME,            
		[PAYMENTLAYOUTVERSION]= @PAYMENTLAYOUTVERSION,          
		[WORKSTATION]   = @WORKSTATION,                   
		[ISDEFAULT]     = @ISDEFAULT,                     
		[LASTCHANGEDBY] = @LASTCHANGEDBY,                 
		[LASTCHANGEDON] = @LASTCHANGEDON,                 
		[ROWVERSION]    = @ROWVERSION + 1,                    
		[VENDORNUMBER] = @VENDORNUMBER,
		[INCLUDENSF] = @INCLUDENSF	
		
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
WHERE
	[CAFINANCIALINTEGRATIONSETUPID] = @CAFINANCIALINTEGRATIONSETUPID AND
	[ROWVERSION]= @ROWVERSION

SELECT * FROM @OUTPUTTABLE