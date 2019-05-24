unit Nathan.Lib.EventDispatcher.Tests;

interface

uses
  DUnitX.TestFramework;

{$M+}

type
  [TestFixture]
  TTestEventDispatcher = class
  private
    FHasCalled: Integer;
    procedure ToCallEvent;
  public
    [Setup]
    procedure SetUp();

    [TearDown]
    procedure TearDown();

    [Test]
    procedure Test_CanCreate_DummyClass;

    [Test]
    procedure Test_EventDispatcherOnDummyClass;
  end;

{$M-}

implementation

uses
  Nathan.EventDispatcher,
  Nathan.Lib.EventDispatcher.DummyClass;

{ TTestEventDispatcher }

procedure TTestEventDispatcher.SetUp;
begin
  FHasCalled := 0;
end;

procedure TTestEventDispatcher.TearDown;
begin
end;

procedure TTestEventDispatcher.ToCallEvent;
begin
  Inc(FHasCalled);
end;

procedure TTestEventDispatcher.Test_CanCreate_DummyClass;
var
  Cut: IEventDummyClass;
begin
  Cut := TEventDummyClass.Create();
  Cut.CheckException(ToCallEvent);
  Cut.Calling;
  Assert.IsNotNull(Cut);
  Assert.AreEqual(1, FHasCalled);
end;

procedure TTestEventDispatcher.Test_EventDispatcherOnDummyClass;
var
  Cut: IEventDummyClass;
begin
  Cut := TEventDummyClass.Create();

  //  Test with fix class...
  //  Cut.CheckException(TNathanEventDispatcher.Construct(
  //    procedure
  //    begin
  //      Inc(FHasCalled);
  //    end));

  Cut.CheckException(TNathanEventDispatcher<TInnerTestMethod>.Construct(
    procedure
    begin
      Inc(FHasCalled);
    end));

  Cut.Calling;
  Assert.IsNotNull(Cut);
  Assert.AreEqual(1, FHasCalled);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestEventDispatcher, 'TTestEventDispatcher');

end.
