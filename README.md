# csv-haskell

A simple CSV parser in Haskell, using Parsec!

## CSV Specification

From [Common Format and MIME Type for Comma-Separated Values (CSV) Files](https://www.ietf.org/rfc/rfc4180.txt) by Y. Shafranovic:

> The ABNF grammar [2] appears as follows:
>
> ```
> file = [header CRLF] record *(CRLF record) [CRLF]
> 
> header = name *(COMMA name)
> 
> record = field *(COMMA field)
> 
> name = field
> 
> field = (escaped / non-escaped)
> 
> escaped = DQUOTE *(TEXTDATA / COMMA / CR / LF / 2DQUOTE) DQUOTE
> 
> non-escaped = *TEXTDATA
> 
> COMMA = %x2C
> 
> CR = %x0D ;as per section 6.1 of RFC 2234 [2]
> 
> DQUOTE =  %x22 ;as per section 6.1 of RFC 2234 [2]
> 
> LF = %x0A ;as per section 6.1 of RFC 2234 [2]
> 
> CRLF = CR LF ;as per section 6.1 of RFC 2234 [2]
> 
> TEXTDATA =  %x20-21 / %x23-2B / %x2D-7E
> ```

