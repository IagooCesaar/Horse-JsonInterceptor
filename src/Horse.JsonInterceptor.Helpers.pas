unit Horse.JsonInterceptor.Helpers;

interface

uses
  System.Json,
  REST.Json;

type
  TJsonOption = REST.Json.TJsonOption;
  TJsonOptions = REST.Json.TJsonOptions;
  TJson = REST.Json.TJson;

  THorseJsonInterceptorHelperRestJson = class helper for Rest.Json.TJson
  public
    class function ObjectToClearJsonValue(AObject: TObject; AOptions: TJsonOptions = [joDateIsUTC, joDateFormatISO8601]): TJSONValue;
    class function ObjectToClearJsonObject(AObject: TObject; AOptions: TJsonOptions = [joDateIsUTC, joDateFormatISO8601]): TJSONObject;
    class function ObjectToClearJsonString(AObject: TObject; AOptions: TJsonOptions = [joDateIsUTC, joDateFormatISO8601]): string;

    class function ClearJsonAndConvertToObject<T: class, constructor>(AJsonObject: TJSONObject; AOptions: TJsonOptions = [joDateIsUTC, joDateFormatISO8601]): T; overload;
    class function ClearJsonAndConvertToObject<T: class, constructor>(const AJson: string; AOptions: TJsonOptions = [joDateIsUTC, joDateFormatISO8601]): T; overload;
  end;

implementation

uses Horse.JsonInterceptor.Core;

{ TBDMGHorseToolsHelperRestJson }

class function THorseJsonInterceptorHelperRestJson.ClearJsonAndConvertToObject<T>(
  AJsonObject: TJSONObject; AOptions: TJsonOptions): T;
var LJsonModified: TJSONObject;
begin
  LJsonModified := THorseJsonInterceptor.CriarListHelperArray(
    AJsonObject as TJsonValue) as TJSONObject;

  Result := Self.JsonToObject<T>(LJsonModified, AOptions);
  LJsonModified.DisposeOf;
end;

class function THorseJsonInterceptorHelperRestJson.ClearJsonAndConvertToObject<T>(
  const AJson: string; AOptions: TJsonOptions): T;
var LClearJson: String;
begin
  LClearJson := THorseJsonInterceptor.CriarListHelperArray(AJson);

  Result := Self.JsonToObject<T>(LClearJson, AOptions);
end;

class function THorseJsonInterceptorHelperRestJson.ObjectToClearJsonValue(
  AObject: TObject; AOptions: TJsonOptions): TJSONValue;
var LJson: TJSONObject;
begin
  LJson := Self.ObjectToJsonObject(AObject, AOptions);
  try
    Result := THorseJsonInterceptor.RemoverListHelperArray(
      LJson as TJsonValue);
  finally
    LJson.DisposeOf;
  end;
end;

class function THorseJsonInterceptorHelperRestJson.ObjectToClearJsonObject(
  AObject: TObject; AOptions: TJsonOptions): TJSONObject;
begin
  Result := ObjectToClearJsonValue(AObject, AOptions) as TJSONObject;
end;

class function THorseJsonInterceptorHelperRestJson.ObjectToClearJsonString(
  AObject: TObject; AOptions: TJsonOptions): string;
begin
  Result := Self.ObjectToJsonString(AObject, AOptions);

  Result := THorseJsonInterceptor.RemoverListHelperArray(Result);
end;

end.
