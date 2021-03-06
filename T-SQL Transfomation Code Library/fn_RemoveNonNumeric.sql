/****** Object:  UserDefinedFunction [dbo].[fn_RemoveNonNumeric]    Script Date: 02/25/2015 16:06:31 ******/
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
