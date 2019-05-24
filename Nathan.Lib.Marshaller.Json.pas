unit Nathan.Lib.Marshaller.Json;

///   Inspired by follow links:
///   https://purodelphi.com/2017/04/08/serializacion-json-en-tokyo/
///   http://www.sql.ru/forum/1230862-31/kakie-novosti-v-mire-delphi
///   ...
///   Serialize and deserialize a collection to JSON Delphi
///   https://stackoverflow.com/questions/42808092/serialize-and-deserialize-a-collection-to-json-delphi
///   http://www.clevercomponents.com/articles/article040/
///   https://community.embarcadero.com/blogs/entry/how-to-convert-an-object-to-json-and-back-with-a-single-line-of-code-497
///   http://chapmanworld.com/2015/01/18/json-with-radstudio-delphi-or-c-builder/
///   https://flixengineering.com/archives/139
///   ...
///   https://community.embarcadero.com/blogs/entry/tjsonserializer-json-japan
///   http://d.hatena.ne.jp/tales/20170331/1490975195
///   http://d.hatena.ne.jp/tales/20170402/1491141694

interface

uses
  {$IF RTLVersion>=32}  // Rad Studio Tokyo or we use //{$IFDEF VER320}
    System.JSON.Serializers,
  {$ELSE}
    //  XSuperObject,
    //  System.JSON.Types,
    //  System.Generics.Collections,
  {$ENDIF}
  System.Classes;

type
  TNathanSerializer = class
  private
    FSerializer: TJsonSerializer;
  public
    constructor Create();
    destructor Destroy(); override;

    function Deserialize<T>(const data: string): T;
    function Serialize<T>(const obj: T): string;
  end;

implementation

uses
  System.JSON.Types;

{ TNathanSerializer }

constructor TNathanSerializer.Create();
begin
  inherited Create;
  {$IF RTLVersion>=32}
    FSerializer := TJsonSerializer.Create;
    //  FSerializer.Formatting := TJsonFormatting.Indented;  //  Line Breaks...
    FSerializer.DateFormatHandling := TJsonDateFormatHandling.Iso;
  {$ELSE}
  {$ENDIF}
end;

destructor TNathanSerializer.Destroy();
begin
  {$IF RTLVersion>=32}
    FSerializer.Free;
  {$ELSE}
  {$ENDIF}
  inherited;
end;

function TNathanSerializer.Deserialize<T>(const data: string): T;
begin
  {$IF RTLVersion>=32}
    Result := FSerializer.Deserialize<T>(data);
  {$ELSE}
    //  Result := TJSON.Parse<T>(data);
  {$ENDIF}
end;

function TNathanSerializer.Serialize<T>(const obj: T): string;
begin
  {$IF RTLVersion>=32}
    //    Result := FSerializer.Serialize(obj);
    Result := FSerializer.Serialize<T>(obj);
  {$ELSE}
    //  Another option with SuperObject from https://github.com/hgourvest
    //  Result := TJSON.SuperObject<T>(obj).AsJSON;

    //  or from delphi self with uses Rest.Json
    //  Result := TJson.ObjectToJsonString(Self);
  {$ENDIF}
end;

end.

