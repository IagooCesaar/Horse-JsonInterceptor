unit Controllers.HelperExample;

interface

procedure Registry;

implementation

uses
  Horse,
  Horse.JsonInterceptor.Helpers,
  Horse.JsonInterceptor.Example.Classes;

procedure DoSomething(var ABody: TBody);
var I: Integer;
begin
  for I := 0 to Pred(ABody.Lista.Count) do
    ABody.Lista[i].Code := ABody.Lista[i].Code * 10;
end;

procedure PostWithHelper(Req: THorseRequest; Resp: THorseResponse);
var LBody: TBody;
begin
  LBody := TJson.ClearJsonAndConvertToObject<TBody>(Req.Body);

  DoSomething(LBody);

  Resp.Send(
    TJson.ObjectToClearJsonString(LBody)
  );
end;

procedure Registry;
begin
  THorse
    .Post('with-helper', PostWithHelper)
end;

end.
