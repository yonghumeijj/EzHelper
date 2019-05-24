unit Nathan.Lib.Marshaller.DummyClass;

interface

uses
  System.JSON.Serializers,
  System.JSON.Converters,

  System.Generics.Collections,

  System.JSON.Writers,
  System.TypInfo,
  System.Rtti;

{$DEFINE NOPLATFORMSPEC}

{$M+}

type
  TFooType = (ftNormal, ftRunner, ftFast, ftFaster, ftFastest);

  IAnotherDummy = interface
    ['{B4FFE2A1-EFAB-4243-9966-8C7DA2E4E29B}']
    function GetAssembly(): string;
    procedure SetAssembly(const Value: string);

    property Assembly: string read GetAssembly write SetAssembly;
  end;

  INathanDummy = interface
    ['{261C4E59-3DF2-4756-9892-2D7E8C67E1E4}']
    function GetId(): Integer;
    function GetMessageBody(): string;
    function GetInternalType(): TFooType;
    function GetVersion(): Integer;
    function GetAnother(): IAnotherDummy;

    procedure SetId(Value: Integer);
    procedure SetMessageBody(const Value: string);
    procedure SetInternalType(Value: TFooType);
    procedure SetVersion(Value: Integer);
    procedure SetAnother(Value: IAnotherDummy);

    property Id: Integer read GetId write SetId;
    property MessageBody: string read GetMessageBody write SetMessageBody;
    property InternalType: TFooType read GetInternalType write SetInternalType;
    property Version: Integer read GetVersion write SetVersion;
    property Another: IAnotherDummy read GetAnother write SetAnother;
  end;

  [JsonSerialize(TJsonMemberSerialization.&In)]
  TAnotherDummy = class(TInterfacedObject, IAnotherDummy)
  strict private
    [JsonIn]
    [JsonName('Assembly')]
    FAssembly: string;
  private
    function GetAssembly(): string;
    procedure SetAssembly(const Value: string);
  public
    constructor Create();

    [ALIAS('Assembly')]
    property Assembly: string read GetAssembly write SetAssembly;
  end;


  TJsonCustomCreationConverterAnotherDummy = class(TJsonCustomCreationConverter<TAnotherDummy>)
  protected
    function CreateInstance(ATypeInf: PTypeInfo): TValue; override;
  public
    procedure WriteJson(const AWriter: TJsonWriter; const AValue: TValue; const ASerializer: TJsonSerializer); override;
  end;

  /// <summary>
  ///   Demo Class to serialization in json.
  ///   Another class option for the new de-/serializer:
  ///     [JsonSerialize(TJsonMemberSerialization.&Public)] Serialize all public fields and properties from my and inherited classes...
  ///     [JsonSerialize(TJsonMemberSerialization.Fields)]
  ///     [JsonSerialize(TJsonMemberSerialization.&In)] Just only fields with attribute JsonIn...
  /// </summary>

  [JsonSerialize(TJsonMemberSerialization.&In)]
  TNathanDummy = class(TInterfacedObject, INathanDummy)
  strict private
    [JsonIgnore]  //  Ignore this field when serializing...
    FId: Integer;

    [JsonIn]
    [JsonName('messagebody')]
    FMessageBody: string;

    [JsonIn]
    [JsonName('type')]
    [JsonConverter(TJsonEnumNameConverter)]
    //  [ObjectHandlingAttribute(TJsonObjectHandling.Replace)]
    //  [JsonObjectOwnership(TJsonObjectOwnership.NotOwned)]
    FInternalType: TFooType;

    [JsonIn]
    [JsonName('ver')]
    FVersion: Integer;

    [JsonIn]
    [JsonName('Another')]
    [JsonConverter(TJsonCustomCreationConverterAnotherDummy)]
    //  [JsonIgnore]
    FAnother: IAnotherDummy;
  private
    function GetId(): Integer;
    function GetMessageBody(): string;
    function GetInternalType(): TFooType;
    function GetVersion(): Integer;
    function GetAnother(): IAnotherDummy;

    procedure SetId(Value: Integer);
    procedure SetMessageBody(const Value: string);
    procedure SetInternalType(Value: TFooType);
    procedure SetVersion(Value: Integer);
    procedure SetAnother(Value: IAnotherDummy);
  public
    constructor Create(AId: Integer; const AMessageBody: string; AType: TFooType; AVersion: Integer); overload;
    destructor Destroy(); override;

    property Id: Integer read GetId write SetId;

    [ALIAS('messagebody')]
    property MessageBody: string read GetMessageBody write SetMessageBody;

    [ALIAS('type')]
    property InternalType: TFooType read GetInternalType write SetInternalType;

    [ALIAS('ver')]
    property Version: Integer read GetVersion write SetVersion;

    [ALIAS('Another')]
    property Another: IAnotherDummy read GetAnother write SetAnother;
  end;

{$M-}

implementation

{ **************************************************************************** }

{ TAnotherDummy }

constructor TAnotherDummy.Create;
begin
  inherited;
  FAssembly := 'Baugruppe';
end;

function TAnotherDummy.GetAssembly: string;
begin
  Result := FAssembly;
end;

procedure TAnotherDummy.SetAssembly(const Value: string);
begin
  FAssembly := Value;
end;

{ **************************************************************************** }

{ TJsonCustomCreationConverterAnotherDummy }

function TJsonCustomCreationConverterAnotherDummy.CreateInstance(ATypeInf: PTypeInfo): TValue;
begin
  Result := TAnotherDummy.Create;
end;

procedure TJsonCustomCreationConverterAnotherDummy.WriteJson(
  const AWriter: TJsonWriter; const AValue: TValue;
  const ASerializer: TJsonSerializer);
var
  AnotherDummy: IAnotherDummy;
begin
  //  http://robstechcorner.blogspot.ch/2009/09/tvalue-in-depth.html
  //  inherited;

  if AValue.TryAsType(AnotherDummy) then
    ASerializer.Serialize(AWriter, AnotherDummy as TAnotherDummy);
end;

{ **************************************************************************** }

{ TNathanDummy }

constructor TNathanDummy.Create(AId: Integer; const AMessageBody: string; AType: TFooType; AVersion: Integer);
begin
  inherited Create;
  FId := AId;
  FMessageBody := AMessageBody;
  FInternalType := AType;
  FVersion := AVersion;
  FAnother := TAnotherDummy.Create;
end;

destructor TNathanDummy.Destroy();
begin
  FAnother := nil;
  inherited;
end;

function TNathanDummy.GetAnother: IAnotherDummy;
begin
  Result := FAnother;
end;

function TNathanDummy.GetId: Integer;
begin
  Result := FId;
end;

function TNathanDummy.GetInternalType: TFooType;
begin
  Result := FInternalType;
end;

function TNathanDummy.GetMessageBody: string;
begin
  Result := FMessageBody;
end;

function TNathanDummy.GetVersion: Integer;
begin
  Result := FVersion;
end;

procedure TNathanDummy.SetAnother(Value: IAnotherDummy);
begin
  FAnother := Value;
end;

procedure TNathanDummy.SetId(Value: Integer);
begin
  FId := Value;
end;

procedure TNathanDummy.SetInternalType(Value: TFooType);
begin
  FInternalType := Value;
end;

procedure TNathanDummy.SetMessageBody(const Value: string);
begin
  FMessageBody := Value;
end;

procedure TNathanDummy.SetVersion(Value: Integer);
begin
  FVersion := Value;
end;

end.
