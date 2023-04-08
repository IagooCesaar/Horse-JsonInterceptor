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
  REST.Json;

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
  private
    class function InternalRemoverListHelperVerificaObjeto(AJsonObject: TJSONValue): TJSONValue;
    class function InternalRemoverListHelperVerificaPropriedade(AJsonPair: TJSONPair): TJSONPair;
    class function InternalRemoverListHelperVerificaArray(LJsonValue: TJSONValue): TJSONArray;

    class procedure InternalCriarListHelperVerificaPropriedade(AJsonPair: TJSONPair);
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
var LJsonOriginal, LJsonModified: TJSONValue; LJson: TJSONObject;
begin
  try
    LJsonOriginal := TJSONValueFPCDelphi.ParseJSONValue(AJsonString);

    LJsonModified := CriarListHelperArray(LJsonOriginal);
    Result        := LJsonModified.ToString;

    LJsonModified.Free;
    LJsonOriginal.Free;
  except
    Result := AJsonString;
  end;
end;

class function THorseJsonInterceptor.CriarListHelperArray(
  AJson: TJSONValueFPCDelphi): TJSONValueFPCDelphi;
var
  LJsonBody: TJSONValue;
  LJsonPair: TJSONPair;
  R: Integer;
  LJson: TJSONObject;
begin
  LJson := TJSONObject.Create;
  LJson.AddPair('originalPair', AJson.Clone as TJSONValue);

  LJsonBody := LJson.Clone as TJSONValue;
  try
    if LJsonBody is TJSONObject then
      for R := 0 to Pred(TJSONObject(LJsonBody).Count) do begin
        LJsonPair := TJSONObject(LJsonBody).Pairs[R];
        InternalCriarListHelperVerificaPropriedade(LJsonPair);
      end;

    Result := TJSONObject(LJsonBody).GetValue('originalPair').Clone as TJSONValue;
    LJson.Free;
    LJsonBody.Free;
  except
    Result := AJson;
  end;
end;

class procedure THorseJsonInterceptor.InternalCriarListHelperVerificaPropriedade(
  AJsonPair: TJSONPair);
var
  I, P: Integer;
  LJsonValue, LJsonChildValue: TJSONValue;
  LJsonListHelperPair: TJSONPair;
  LJsonPropPair, LJsonChildPair: TJSONPair;
  LJsonOjectList: TJSONObject;
  LJsonArray: TJSONArray;
begin
  if AJsonPair.JsonValue.Null then Exit;
  LJsonValue := AJsonPair.JsonValue.Clone as TJSONValue;

  if LJsonValue is TJSONObject then begin
    for I := 0 to Pred(TJSONObject(LJsonValue).Count) do begin
      LJsonPropPair := TJSONObject(LJsonValue).Pairs[I];
      InternalCriarListHelperVerificaPropriedade(LJsonPropPair);
    end;
  end;

  if LJsonValue is TJSONArray then begin

    LJsonArray := LJsonValue as TJSONArray;

    for I := 0 to Pred(LJsonArray.Count) do begin
      LJsonChildValue :=  LJsonArray.Items[I];
      if LJsonChildValue.Null then Continue;

      if LJsonChildValue is TJSONObject then
        for P := 0 to Pred(TJSONObject(LJsonChildValue).Count) do begin
          LJsonChildPair := TJSONObject(LJsonChildValue).Pairs[P];
          InternalCriarListHelperVerificaPropriedade(LJsonChildPair);
        end;
    end;

    // Se array contiver elementos, verifica se tem objeto.
    // Se não tiver elementos, assume que teria objetos
    if ((LJsonArray.Count > 0) and (LJsonArray.Items[0] is TJSONObject))
    or (LJsonArray.Count = 0)
    then begin
      // converte o Array em ObjectList
      LJsonListHelperPair := TJSONPair.Create('listHelper', LJsonValue as TJSONArray);
      LJsonOjectList := TJSONObject.Create;
      LJsonOjectList.AddPair(LJsonListHelperPair);
      LJsonValue := LJsonOjectList as TJSONValue;
    end;
  end;

  AJsonPair.JsonValue := LJsonValue;
end;

class function THorseJsonInterceptor.InternalRemoverListHelperVerificaArray(
  LJsonValue: TJSONValue): TJSONArray;
var
  I, P: Integer;
  LJsonChildValue: TJSONValue;
  LOriginalChildPair, LModifiedChildPair: TJSONPair;
  LOriginalArray, LModifiedArray: TJSONArray;
  LChildObject: TJSONObject;
begin
  LOriginalArray := LJsonValue as TJSONArray;
  LModifiedArray := TJSONArray.Create;

  for I := 0 to Pred(LOriginalArray.Count) do begin

    LJsonChildValue :=  LOriginalArray.Items[I];
    if not LJsonChildValue.Null then begin

      if LJsonChildValue is TJSONObject then begin
        LChildObject := TJSONObject.Create;

        for P := 0 to Pred(TJSONObject(LJsonChildValue).Count) do begin
          LOriginalChildPair := TJSONObject(LJsonChildValue).Pairs[P];
          LModifiedChildPair := InternalRemoverListHelperVerificaPropriedade(LOriginalChildPair);
          LChildObject.AddPair(LModifiedChildPair);
        end;

        LModifiedArray.AddElement(LChildObject);
      end else
        LModifiedArray.AddElement(LJsonChildValue.Clone as TJSONValue);

    end else
      LModifiedArray.AddElement(LJsonChildValue.Clone as TJSONValue);

  end;
  Result := LModifiedArray.Clone as TJSONArray;
  LModifiedArray.Free;
end;

class function THorseJsonInterceptor.InternalRemoverListHelperVerificaObjeto(
  AJsonObject: TJSONValue): TJSONValue;
var LListHelperJsonArray, LClone: TJSONValue;
begin
  // Se object contiver 'listHelper', substituir valor do objeto pelo
  // array contido em 'listHelper'
  if AJsonObject.TryGetValue('listHelper', LListHelperJsonArray)
  then LClone := LListHelperJsonArray.Clone as TJSONValue
  else LClone := AJsonObject.Clone as TJSONValue;

  Result := LClone;
end;

class function THorseJsonInterceptor.InternalRemoverListHelperVerificaPropriedade(
  AJsonPair: TJSONPair): TJSONPair;
var
  I, P: Integer;
  LJsonValue, LTempValue: TJSONValue;
  LOriginalPropPair, LModifiedPropPair: TJSONPair;
  LModifiedArray: TJSONArray;
  LNewObject: TJSONObject;
begin
  if AJsonPair.JsonValue.Null then begin
    Result := AJsonPair.Clone as TJSONPair;
    Exit;
  end;

  LTempValue := AJsonPair.JsonValue.Clone as TJSONValue;

  //Se for objeto, verifica se é ObjectList
  if AJsonPair.JsonValue is TJSONObject
  then LJsonValue := InternalRemoverListHelperVerificaObjeto(LTempValue)
  else LJsonValue := AJsonPair.JsonValue.Clone as TJSONValue;

  if   LTempValue <> nil
  then FreeAndNIl(LTempValue);

  //Se ainda for objeto, verificar propriedades
  if LJsonValue is TJSONObject then
  begin
    LNewObject := TJSONObject.Create;
    for I := 0 to Pred(TJSONObject(LJsonValue).Count) do begin
      LOriginalPropPair := TJSONObject(LJsonValue).Pairs[I];
      LModifiedPropPair := InternalRemoverListHelperVerificaPropriedade(LOriginalPropPair);
      LNewObject.AddPair(LModifiedPropPair);
    end;

    FreeAndNil(LJsonValue);
    LJsonValue := LNewObject.Clone as TJSONValue;
    FreeAndNil(LNewObject);
  end;

  // Se for Array, verificar cada item
  if LJsonValue is TJSONArray then
  begin
    LModifiedArray := InternalRemoverListHelperVerificaArray(LJsonValue);

    LJsonValue.Free;
    LJsonValue := LModifiedArray.Clone as TJSONValue;
    LModifiedArray.Free;
  end;

  Result := TJSONPair.Create(
    TJSONString(AJsonPair.JsonString.Clone),
    LJsonValue );
end;

class function THorseJsonInterceptor.RemoverListHelperArray(
  AJsonString: string): string;
var LJsonOriginal, LJsonModified: TJSONValue;
begin
  try
    LJsonOriginal := TJSONObject.ParseJSONValue(AJsonString) as TJSONObject;
    LJsonModified := RemoverListHelperArray(LJsonOriginal);
    Result        := LJsonModified.ToString;

    FreeAndNIl(LJsonOriginal);
    FreeAndNIl(LJsonModified);
  except
    Result    := AJsonString;
  end;
end;

class function THorseJsonInterceptor.RemoverListHelperArray(
  AJson: TJSONValueFPCDelphi): TJSONValueFPCDelphi;
var LOriginalPair, LModifiedPair : TJSONPair;
begin
  try
    LOriginalPair := TJSONPair.Create( 'originalPair', AJson.Clone as TJSONValue );
    LModifiedPair := InternalRemoverListHelperVerificaPropriedade(LOriginalPair);
    Result := LModifiedPair.JsonValue.Clone as TJSONValue;

    LModifiedPair.Free;
    LOriginalPair.Free;
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

