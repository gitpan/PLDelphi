unit PLDelphi_dll ;

interface

uses
  SysUtils ;

{******************************************************************************}

type
   SV = class(TObject)
   private
     ID : Integer ;
   public
     function call( method : String ) : String; overload ;
     function call( method , args : String ) : String; overload ;
     function call_sv( method : String ) : SV; overload ;
     function call_sv( method , args : String ) : SV; overload ;

     constructor Create( newid : String );
end;

{******************************************************************************}

type
   Perl = class(TObject)
   private
     ID : Integer ;
   public

     class function error() : String; overload ;

     class function eval( code : String ) : String; overload ;
     class function eval_sv( code : String ) : SV; overload ;
     class function eval_int( code : String ) : Integer; overload ;
     class function quoteit( s : String ) : String; overload ;

     class function NEW( pkg : String ) : SV; overload ;
     class function NEW( pkg , args : String ) : SV; overload ;

     class function use( pkg : String ) : Boolean; overload ;
     class function use( pkg , args : String ) : Boolean; overload ;
end;

{******************************************************************************}

  function PLDelphi_start: Integer; cdecl;
  function PLDelphi_eval( code : Pchar ) : Pchar; cdecl;
  function PLDelphi_eval_sv( code : Pchar ) : Pchar; cdecl;
  function PLDelphi_error : Pchar; cdecl;
  procedure PLDelphi_stop ; cdecl;

implementation

{******************************************************************************}

class function Perl.error() : String;
begin
  Result := PLDelphi_error() ;
end;

class function Perl.eval( code : String ) : String;
begin
  Result := PLDelphi_eval( PChar(code) ) ;
end;

class function Perl.eval_sv( code : String ) : SV ;
begin
  Result := SV.Create( PLDelphi_eval_sv( PChar(code) ) ) ;
end;

class function Perl.eval_int( code : String ) : Integer;
begin
  Result := StrtoInt( PLDelphi_eval( PChar(code) ) ) ;
end;

class function Perl.NEW( pkg : String ) : SV;
begin
  Result := eval_sv( PChar('new ' + pkg + '()') ) ;
end;

class function Perl.NEW( pkg , args : String ) : SV;
begin
  Result := eval_sv( PChar('new ' + pkg + '('+ args +')') ) ;
end;

class function Perl.use( pkg : String ) : Boolean;
begin
  eval( PChar('use ' + pkg) ) ;
end;

class function Perl.use( pkg , args : String ) : Boolean;
begin
  eval( PChar('use ' + pkg + '('+ args +')') ) ;
end;

class function Perl.quoteit( s : String ) : String;
var
  str , t : String ;
  i : Integer ;
begin
  str := '''' ;

  for i := 1 to Length(s) do
  begin
    t := Copy( s , i , 1 ) ;

    if (t = '\') or (t = '''') then
    begin
      str := str + '\' + t ;
    end
    else
    begin
      str := str + t ;
    end;
  end;

  str := str + '''' ;

  Result := str ;
end;

{******************************************************************************}

constructor SV.Create( newid : String );
begin
  ID := StrtoInt(newid) ;
end;

function SV.call( method : String ) : String;
begin
  Result := Perl.eval('PLDelphi::SV_call('+ InttoStr(ID) +' , '+ Perl.quoteit(method) +')') ;
end;

function SV.call( method , args : String ) : String;
begin
  Result := Perl.eval('PLDelphi::SV_call('+ InttoStr(ID) +' , '+ Perl.quoteit(method) +' , '+ args +')' ) ;
end;

function SV.call_sv( method : String ) : SV;
begin
  Result := Perl.eval_sv('PLDelphi::SV_call('+ InttoStr(ID) +' , '+ Perl.quoteit(method) +')') ;
end;

function SV.call_sv( method , args : String ) : SV;
begin
  Result := Perl.eval_sv('PLDelphi::SV_call('+ InttoStr(ID) +' , '+ Perl.quoteit(method) +' , '+ args +')' ) ;
end;

{******************************************************************************}

const
  PLDELPHI_DLL_NAME = 'PLDelphi.dll' ;

function PLDelphi_start; external PLDELPHI_DLL_NAME name 'PLDelphi_start';

function PLDelphi_eval; external PLDELPHI_DLL_NAME name 'PLDelphi_eval' ;
function PLDelphi_eval_sv; external PLDELPHI_DLL_NAME name 'PLDelphi_eval_sv' ;

function PLDelphi_error; external PLDELPHI_DLL_NAME name 'PLDelphi_error' ;

procedure PLDelphi_stop; external PLDELPHI_DLL_NAME name 'PLDelphi_stop';

{******************************************************************************}

begin
  PLDelphi_start() ;
end.

{******************************************************************************}
