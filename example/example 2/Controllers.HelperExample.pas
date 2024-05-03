unit Controllers.HelperExample;

interface

procedure Registry;

implementation

uses
  System.SysUtils,
  Horse,
  Horse.Exception,
  REST.Json,
  Horse.JsonInterceptor.Helpers,
  Horse.JsonInterceptor.Example.Classes;

procedure DoSomething(var ABody: TFamilia);
var I: Integer;
begin
  for I := 0 to Pred(ABody.Membros.Count) do
    ABody.Membros[i].Codigo := ABody.Membros[i].Codigo * 10;
end;

procedure PostWithHelper_Familia(Req: THorseRequest; Resp: THorseResponse);
var LBody: TFamilia;
begin
  LBody := TJson.ClearJsonAndConvertToObject<TFamilia>(Req.Body);

  DoSomething(LBody);

  Resp.Status(201).Send(
    TJson.ObjectToClearJsonString(LBody)
  );

  LBody.Free;
end;

procedure PostWithHelper_Biblioteca(Req: THorseRequest; Resp: THorseResponse);
var LBody: TBiblioteca;
begin
  LBody := TJson.ClearJsonAndConvertToObject<TBiblioteca>(Req.Body);

  Resp.Status(201).Send(
    TJson.ObjectToClearJsonString(LBody)
  );

  LBody.Free;
end;

procedure PostWithHelper_Empresa(Req: THorseRequest; Resp: THorseResponse);
var LBody: TEmpresa;
begin
  LBody := TJson.ClearJsonAndConvertToObject<TEmpresa>(Req.Body);

  Resp.Status(201).Send(
    TJson.ObjectToClearJsonString(LBody)
  );

  LBody.Free;
end;

procedure PostWithHelper_Garagem(Req: THorseRequest; Resp: THorseResponse);
var LBody: TGaragem;
begin
  LBody := TJson.ClearJsonAndConvertToObject<TGaragem>(Req.Body);

  Resp.Status(201).Send(
    TJson.ObjectToClearJsonString(LBody)
  );

  LBody.Free;
end;

procedure PostWithHelper_Escola(Req: THorseRequest; Resp: THorseResponse);
var LBody: TEscola;
begin
  LBody := TJson.ClearJsonAndConvertToObject<TEscola>(Req.Body);

  Resp.Status(201).Send(
    TJson.ObjectToClearJsonString(LBody)
  );

  LBody.Free;
end;

procedure PostWithHelper_Pessoas(Req: THorseRequest; Resp: THorseResponse);
var LBody: TPessoas;
begin
  LBody := TJson.ClearJsonAndConvertToObject<TPessoas>(Req.Body);

  Resp.Status(201).Send(
    TJson.ObjectToClearJsonString(LBody)
  );

  LBody.Free;
end;

procedure PostWithHelper_Todos(Req: THorseRequest; Resp: THorseResponse);
var LBody: TTodos;
begin
  LBody := TJson.ClearJsonAndConvertToObject<TTodos>(Req.Body);

  Resp.Status(201).Send(
    TJson.ObjectToClearJsonString(LBody)
  );

  LBody.Free;
end;

procedure PostWithHelper_Musica(Req: THorseRequest; Resp: THorseResponse);
var LBody, LValidado: TMusica;
begin
  LBody := TJson.ClearJsonAndConvertToObject<TMusica>(Req.Body);
  try
    try
      LValidado := TJson.RevalidateSetters<TMusica>(LBody);
      LValidado.Free;
    except
      on e: Exception
      do raise EHorseException.New
        .Status(THTTPStatus.PreconditionFailed)
        .Error(e.Message);
    end;

    Resp.Status(201).Send(
      TJson.ObjectToClearJsonString(LBody)
    );
  finally
    LBody.Free;
  end;
end;

procedure Registry;
const CContext = 'with-helper/';
begin
  THorse
    .Post(CContext+'familia', PostWithHelper_Familia)
    .Post(CContext+'biblioteca', PostWithHelper_Biblioteca)
    .Post(CContext+'empresa', PostWithHelper_Empresa)
    .Post(CContext+'garagem', PostWithHelper_Garagem)
    .Post(CContext+'escola', PostWithHelper_Escola)
    .Post(CContext+'pessoas', PostWithHelper_Pessoas)
    .Post(CContext+'musica', PostWithHelper_Musica)
    .Post(CContext+'todos', PostWithHelper_Todos)
end;

end.
