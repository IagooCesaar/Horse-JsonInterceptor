unit Controllers.HelperExample;

interface

procedure Registry;

implementation

uses
  Horse,
  Horse.JsonInterceptor.Helpers,
  Horse.JsonInterceptor.Example.Classes;

procedure DoSomething(var ABody: TFamilia);
var I: Integer;
begin
  for I := 0 to Pred(ABody.Membros.Count) do
    ABody.Membros[i].Codigo := ABody.Membros[i].Codigo * 10;
end;

procedure PostWithHelper(Req: THorseRequest; Resp: THorseResponse);
var LBody: TFamilia;
begin
  LBody := TJson.ClearJsonAndConvertToObject<TFamilia>(Req.Body);

  DoSomething(LBody);

  Resp.Status(201).Send(
    TJson.ObjectToClearJsonString(LBody)
  );

  LBody.Free;
end;

procedure Registry;
const CContext = 'with-helper/';
begin
  THorse
    .Post(CContext+'familia', PostWithHelper)
end;

end.
