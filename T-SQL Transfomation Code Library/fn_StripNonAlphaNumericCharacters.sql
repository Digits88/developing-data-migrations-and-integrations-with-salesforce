Create Function [dbo].[fn_StripNonAlphaNumericCharacters](@Temp VarChar(max))
Returns VarChar(max)
AS
Begin

    Declare @KeepValues as varchar(50)
    Set @KeepValues = '%[^a-z0-9]%'
    While PatIndex(@KeepValues, @Temp) > 0
        Set @Temp = Stuff(@Temp, PatIndex(@KeepValues, @Temp), 1, '')

    Return @Temp
End