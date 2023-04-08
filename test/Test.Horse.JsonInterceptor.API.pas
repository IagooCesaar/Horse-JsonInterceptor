unit Test.Horse.JsonInterceptor.API;

interface

uses
  DUnitX.TestFramework,
  App;

type
  [TestFixture]
  TestTHorseJsonInterceptorAPI = class
  private
    FApp: TApp;
  public
    [SetupFixture]
    procedure SetupFixture;

    [TearDownFixture]
    procedure TearDownFixture;

    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure Teste;
  end;

implementation

procedure TestTHorseJsonInterceptorAPI.Setup;
begin
end;

procedure TestTHorseJsonInterceptorAPI.SetupFixture;
begin
  FApp := TApp.Create;
  FApp.Start;
end;

procedure TestTHorseJsonInterceptorAPI.TearDown;
begin
end;

procedure TestTHorseJsonInterceptorAPI.TearDownFixture;
begin
  FApp.Stop;
  FApp.Free;
end;

procedure TestTHorseJsonInterceptorAPI.Teste;
begin
  Assert.IsTrue(True);
end;

initialization
  TDUnitX.RegisterTestFixture(TestTHorseJsonInterceptorAPI);

end.
