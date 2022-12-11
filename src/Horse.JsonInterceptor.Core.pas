unit Horse.JsonInterceptor.Core;

{$IF DEFINED(FPC)}
{$MODE DELPHI}{$H+}
{$ENDIF}

interface

uses
{$IF DEFINED(FPC)}
  SysUtils, Classes, HTTPDefs, fpjson, jsonparser,
{$ELSE}
  System.Classes, System.JSON, System.SysUtils, Web.HTTPApp,
{$ENDIF}
  Horse, Horse.Commons, REST.Json;

type

  TJSONValueFPCDelphi = {$IF DEFINED(FPC)}TJsonData{$ELSE}TJSONValue{$ENDIF};

  THorseJsonInterceptorRequest = class(TJSONValueFPCDelphi)
    public
      function ToString: string; overload;
      function ToObject<T: class, constructor>: T;
  end;

  THorseJsonInterceptorResponse = class(TObject)
    public
      function ToString: String; overload;
  end;

  THorseJsonInterceptor = class(TObject)
  public

    class function CriarListHelperArray(AJsonString: string): string; overload;
    class function CriarListHelperArray(AJson: TJSONValueFPCDelphi): TJSONValueFPCDelphi; overload;

    class function RemoverListHelperArray(AJsonString: string): string; overload;
    class function RemoverListHelperArray(AJson: TJSONValueFPCDelphi): TJSONValueFPCDelphi; overload;

  end;


implementation

{$REGION 'THorseJsonInterceptor'}

class function THorseJsonInterceptor.CriarListHelperArray(
  AJsonString: string): string;
var LJsonBody: TJSONValueFPCDelphi;
begin
  try
    LJsonBody := TJSONValueFPCDelphi.Create;
    try
      LJsonBody := TJSONObject.ParseJSONValue(AJsonString) as TJSONObject;
      LJsonBody := CriarListHelperArray(LJsonBody);
      Result    := LJsonBody.ToString;
    except
      Result := AJsonString;
    end;
  finally
    LJsonBody.DisposeOf;
  end;
end;

class function THorseJsonInterceptor.CriarListHelperArray(
  AJson: TJSONValueFPCDelphi): TJSONValueFPCDelphi;
var
  LJsonBody: TJSONValue;
  LJsonPair: TJSONPair;
  R: Integer;

  procedure VerificaPropriedade(var AJsonPair: TJSONPair);
  var
    I, P: Integer;
    LJsonValue, LJsonChildValue: TJSONValue;
    LJsonListHelperPair: TJSONPair;
    LJsonChildPair: TJSONPair;
    LJsonOjectList: TJSONObject;
    LJsonArray: TJSONArray;
  begin
    if AJsonPair.JsonValue.Null then Exit;
    LJsonValue := AJsonPair.JsonValue.Clone as TJSONValue;

    if LJsonValue is TJSONArray then begin

      LJsonArray := LJsonValue as TJSONArray;

      for I := 0 to Pred(LJsonArray.Size) do begin
        LJsonChildValue :=  LJsonArray.Get(I);
        if LJsonChildValue.Null then Continue;

        if LJsonChildValue is TJSONObject then
          for P := 0 to Pred(TJSONObject(LJsonChildValue).Count) do begin
            LJsonChildPair := TJSONObject(LJsonChildValue).Get(P);
            VerificaPropriedade(LJsonChildPair);
          end;
      end;

      // converte o Array em ObjectList
      LJsonListHelperPair := TJSONPair.Create('listHelper', LJsonValue as TJSONArray);
      LJsonOjectList := TJSONObject.Create;
      LJsonOjectList.AddPair(LJsonListHelperPair);
      LJsonValue := LJsonOjectList as TJSONValue;
    end;

    AJsonPair.JsonValue := LJsonValue;
  end;
begin
  LJsonBody := AJson.Clone as TJSONValueFPCDelphi;
  try
    if LJsonBody is TJSONObject then
      for R := 0 to Pred(TJSONObject(LJsonBody).Count) do begin
        LJsonPair := TJSONObject(LJsonBody).Get(R);
        VerificaPropriedade(LJsonPair);
      end;

    Result := LJsonBody;
  except
    Result := AJson;
  end;
end;


class function THorseJsonInterceptor.RemoverListHelperArray(
  AJsonString: string): string;
var LJsonBody: TJSONValueFPCDelphi;
begin
  try
    LJsonBody := TJSONValueFPCDelphi.Create;
    LJsonBody := TJSONObject.ParseJSONValue(AJsonString) as TJSONObject;
    LJsonBody := RemoverListHelperArray(LJsonBody);
    Result    := LJsonBody.ToString;
  except
    Result    := AJsonString;
  end;
end;

class function THorseJsonInterceptor.RemoverListHelperArray(
  AJson: TJSONValueFPCDelphi): TJSONValueFPCDelphi;
var LJsonBody: TJSONValue; R: Integer;  LJsonPair : TJSONPair;

  procedure VerificaObjeto(var AJsonObject: TJSONValue);
  var LJsonValue: TJSONValue;
  begin
    // Se object contiver 'listHelper', substituir valor do objeto pelo
    // array contido em 'listHelper'
    if AJsonObject.TryGetValue('listHelper', LJsonValue) then
      AJsonObject := LJsonValue;
  end;
  procedure VerificaPropriedade(var AJsonPair: TJSONPair);
  var
    I, P: Integer;
    LJsonValue, LJsonChildValue: TJSONValue;
    LJsonChildPair: TJSONPair;
    LJsonArray: TJSONArray;
  begin
    if AJsonPair.JsonValue.Null then Exit;
    LJsonValue := AJsonPair.JsonValue.Clone as TJSONValue;

    //Se for objeto, verifica se é ObjectList
    if AJsonPair.JsonValue is TJSONObject then
      VerificaObjeto(LJsonValue);

    // Se for Array, verificar cada item
    if LJsonValue is TJSONArray then begin
      LJsonArray := LJsonValue as TJSONArray;

      for I := 0 to Pred(LJsonArray.Size) do begin
        LJsonChildValue :=  LJsonArray.Get(I);
        if LJsonChildValue.Null then Continue;

        if LJsonChildValue is TJSONObject then
          for P := 0 to Pred(TJSONObject(LJsonChildValue).Count) do begin
            LJsonChildPair := TJSONObject(LJsonChildValue).Get(P);
            VerificaPropriedade(LJsonChildPair);
          end;
      end;
    end;

    AJsonPair.JsonValue := LJsonValue;
  end;
begin
  try
    LJsonBody := AJson.Clone as TJSONValueFPCDelphi;
    VerificaObjeto(LJsonBody);

    // Percorrer todos Pairs (nós, ou props) do json
    if LJsonBody is TJSONObject then
      for R := 0 to Pred(TJSONObject(LJsonBody).Count) do begin
        LJsonPair := TJSONObject(LJsonBody).Get(R);
        VerificaPropriedade(LJsonPair);
      end;

    Result := LJsonBody as TJSONValueFPCDelphi;
  except
    Result := AJson;
  end;
end;

{$ENDREGION}

{$REGION 'Interceptor Request e Response'}

{ THorseJsonInterceptorRequest }

function THorseJsonInterceptorRequest.ToObject<T>: T;
var LJson: String;
begin
  LJson := Self.ToString;
  Result := TJson.JsonToObject<T>(LJson);
end;

function THorseJsonInterceptorRequest.ToString: string;
begin
  Result := TJSONValueFPCDelphi(Self).ToString;
  Result := THorseJsonInterceptor.CriarListHelperArray(Result);
end;

{ THorseJsonInterceptorResponse }

function THorseJsonInterceptorResponse.ToString: String;
begin
  Result := TJson.ObjectToJsonString(Self);
  Result := THorseJsonInterceptor.RemoverListHelperArray(Result);
end;

{$ENDREGION}

end.

