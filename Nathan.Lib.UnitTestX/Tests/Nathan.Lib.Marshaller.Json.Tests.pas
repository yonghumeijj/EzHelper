unit Nathan.Lib.Marshaller.Json.Tests;

interface

uses
  System.Classes,
  DUnitX.TestFramework,
  Nathan.Lib.Marshaller.Json,
  Nathan.Lib.Marshaller.DummyClass;

{$M+}

type
  [TestFixture]
  TTestNathanSerialization = class
  private
    const NathanDummyAsJson = '{"messagebody":"MyMessageBody","type":"ftRunner","ver":4711,"Another":{"Assembly":"Baugruppe"}}';
  private
    FCut: TNathanSerializer;

    function InitNathanDummy(): TNathanDummy;
    procedure HasExpectedProp(Value: TNathanDummy);
  public
    [Setup]
    procedure SetUp();

    [TearDown]
    procedure TearDown();
  published
    [Test]
    procedure Test_Starter();

    [Test]
    procedure Test_Deserialize();

    [Test]
    procedure Test_Deserialize_UseIntf();

    [Test]
    procedure Test_Deserialize_WithoutAllProp();

    [Test]
    procedure Test_Serialize();

    [Test]
    procedure Test_Serialize_UseIntf();

    [Test]
    procedure Test_Serialize_WithoutAllProp();
  end;

{$M-}

implementation

{ TTestNathanSerialization }

procedure TTestNathanSerialization.SetUp;
begin
  FCut := TNathanSerializer.Create;
end;

procedure TTestNathanSerialization.TearDown;
begin
  FCut.Free;
  FCut := nil;
end;

function TTestNathanSerialization.InitNathanDummy(): TNathanDummy;
begin
  Result := TNathanDummy.Create(1, 'MyMessageBody', TFooType.ftRunner, 4711);
end;

procedure TTestNathanSerialization.HasExpectedProp(Value: TNathanDummy);
begin
  Assert.AreEqual(1, Value.Id);
  Assert.AreEqual('MyMessageBody', Value.MessageBody);
  Assert.AreEqual(TFooType.ftRunner, Value.InternalType);
  Assert.AreEqual(4711, Value.Version);
end;

procedure TTestNathanSerialization.Test_Starter();
var
  Actual: TNathanDummy;
begin
  //  Arrange...
  Actual := TNathanDummy.Create(1, 'MyMessageBody', TFooType.ftRunner, 4711);

  //  Assert...
  HasExpectedProp(Actual);
  Actual.Free;
end;

procedure TTestNathanSerialization.Test_Deserialize();
var
  Actual: TNathanDummy;
begin
  //  Act...
  Actual := FCut.Deserialize<TNathanDummy>(NathanDummyAsJson);

  //  Assert...
  Assert.AreEqual(0, Actual.Id);
  Assert.AreEqual('MyMessageBody', Actual.MessageBody);
  Assert.AreEqual(TFooType.ftRunner, Actual.InternalType);
  Assert.AreEqual(4711, Actual.Version);

  Actual.Free;
end;

procedure TTestNathanSerialization.Test_Deserialize_UseIntf;
var
  Actual: INathanDummy;
begin
  //  Act...
  Actual := FCut.Deserialize<TNathanDummy>(NathanDummyAsJson);

  //  Assert...
  Assert.AreEqual(0, Actual.Id);
  Assert.AreEqual('MyMessageBody', Actual.MessageBody);
  Assert.AreEqual(TFooType.ftRunner, Actual.InternalType);
  Assert.AreEqual(4711, Actual.Version);
end;

procedure TTestNathanSerialization.Test_Deserialize_WithoutAllProp();
const
  ResponseJson = '{"messagebody":"Thurnreiter"}';
var
  Actual: TNathanDummy;
begin
  //  Act...
  Actual := FCut.Deserialize<TNathanDummy>(ResponseJson);

  //  Assert...
  Assert.AreEqual(0, Actual.Id);
  Assert.AreEqual('Thurnreiter', Actual.MessageBody);
  Assert.AreEqual(TFooType.ftNormal, Actual.InternalType);
  Assert.AreEqual(0, Actual.Version);

  Actual.Free;
end;

procedure TTestNathanSerialization.Test_Serialize();
var
  ActualObj: TNathanDummy;
  ReturnValue: string;
begin
  //  Arrange...
  ActualObj := InitNathanDummy();
  try
    //  Act...
    ReturnValue := FCut.Serialize<TNathanDummy>(ActualObj);

    //  Assert...
    Assert.AreEqual(NathanDummyAsJson, ReturnValue);
  finally
    ActualObj.Free;
  end;
end;

procedure TTestNathanSerialization.Test_Serialize_UseIntf();
var
  ActualObj: INathanDummy;
  ReturnValue: string;
begin
  //  Arrange...
  ActualObj := InitNathanDummy();

  //  Act...
  ReturnValue := FCut.Serialize<TNathanDummy>((ActualObj as TNathanDummy));

  //  Assert...
  Assert.AreEqual(NathanDummyAsJson, ReturnValue);
end;

procedure TTestNathanSerialization.Test_Serialize_WithoutAllProp();
const
  Expected = '{"messagebody":"Thurnreiter","type":"ftNormal","ver":0,"Another":null}';
var
  ActualObj: TNathanDummy;
  ReturnValue: string;
begin
  //  Arrange...
  ActualObj := TNathanDummy.Create;
  ActualObj.MessageBody := 'Thurnreiter';

  try
    //  Act...
    ReturnValue := FCut.Serialize<TNathanDummy>(ActualObj);

    //  Assert...
    Assert.AreEqual(Expected, ReturnValue);
  finally
    ActualObj.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TTestNathanSerialization, 'TTestNathanSerialization');

end.
