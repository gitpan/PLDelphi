program ConsoleTest;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  PLDelphi_dll ;

var
  browser , response : SV ;
    
begin

  writeln('***********') ;

  Perl.use('WWW::Mechanize');

  browser := Perl.NEW('WWW::Mechanize');

  response := browser.call_sv('get',' "http://www.terra.com.br/" ') ;

  writeln( response.call('content') ) ;

  writeln('***********') ;

end.
