unit Horse.JsonInterceptor.Helpers;

interface

uses
  System.Json,
  REST.Json;

type
  TJsonOption = REST.Json.TJsonOption;
  TJsonOptions = REST.Json.TJsonOptions;
  TJsonValidationRule = ( joRevalidateSetters );
  TJsonValidationRules = set of TJsonValidationRule;
  TJson = REST.Json.TJson;

  THorseJsonInterceptorHelperRestJson = class helper for Rest.Json.TJson
  public
    const CDefaultValidations = [];

    class function ObjectToClearJsonValue(AObject: TObject;
      AOptions: TJsonOptions = TJson.CDefaultOptions;
      AValidations: TJsonValidationRules = CDefaultValidations
    ): TJSONValue;

    class function ObjectToClearJsonObject(AObject: TObject;
      AOptions: TJsonOptions = TJson.CDefaultOptions;
      AValidations: TJsonValidationRules = CDefaultValidations
    ): TJSONObject;

    class function ObjectToClearJsonString(AObject: TObject;
      AOptions: TJsonOptions = TJson.CDefaultOptions;
      AValidations: TJsonValidationRules = CDefaultValidations
    ): string;


    class function ClearJsonAndConvertToObject<T: class, constructor>(AJsonObject: TJSONObject;
      AOptions: TJsonOptions = TJson.CDefaultOptions;
      AValidations: TJsonValidationRules = CDefaultValidations): T; overload;

    class function ClearJsonAndConvertToObject<T: class, constructor>(const AJson: string;
      AOptions: TJsonOptions = TJson.CDefaultOptions;
      AValidations: TJsonValidationRules = CDefaultValidations): T; overload;

    class function RevalidateSetters<T: class, constructor>(const AObject: T): T; overload;
    class function RevalidateSetters<T: class, constructor>(const AJsonObject: TJsonObject): T; overload;
  end;

implementation

uses Horse.JsonInterceptor.Core;

{ TBDMGHorseToolsHelperRestJson }

class function THorseJsonInterceptorHelperRestJson.ClearJsonAndConvertToObject<T>(
  AJsonObject: TJSONObject; AOptions: TJsonOptions; AValidations: TJsonValidationRules): T;
var LJsonModified: TJSONObject;
begin
  LJsonModified := THorseJsonInterceptor.CriarListHelperArray(
    AJsonObject as TJsonValue) as TJSONObject;

  Result := Self.JsonToObject<T>(LJsonModified, AOptions);
  LJsonModified.DisposeOf;

  if joRevalidateSetters in AValidations
  then begin
    var LObj := Result;
    Result := RevalidateSetters<T>(LObj);
    LObj.Free;
  end;
end;

class function THorseJsonInterceptorHelperRestJson.ClearJsonAndConvertToObject<T>(
  const AJson: string; AOptions: TJsonOptions; AValidations: TJsonValidationRules): T;
var LClearJson: String;
begin
  LClearJson := THorseJsonInterceptor.CriarListHelperArray(AJson);

  Result := Self.JsonToObject<T>(LClearJson, AOptions);

  if joRevalidateSetters in AValidations
  then begin
    var LObj := Result;
    Result := RevalidateSetters<T>(LObj);
    LObj.Free;
  end;
end;

class function THorseJsonInterceptorHelperRestJson.ObjectToClearJsonValue(
  AObject: TObject; AOptions: TJsonOptions; AValidations: TJsonValidationRules): TJSONValue;
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

class function THorseJsonInterceptorHelperRestJson.RevalidateSetters<T>(const AJsonObject: TJsonObject): T;
begin
  var LObject := ClearJsonAndConvertToObject<T>(AJsonObject, [joSerialAllPubProps]);
  Result := LObject;
end;

class function THorseJsonInterceptorHelperRestJson.RevalidateSetters<T>(const AObject: T): T;
begin
  var LJsonObject := ObjectToClearJsonObject(AObject);
  Result := RevalidateSetters<T>(LJsonObject);
  LJsonObject.Free;
end;

class function THorseJsonInterceptorHelperRestJson.ObjectToClearJsonObject(
  AObject: TObject; AOptions: TJsonOptions; AValidations: TJsonValidationRules): TJSONObject;
begin
  Result := ObjectToClearJsonValue(AObject, AOptions) as TJSONObject;
end;

class function THorseJsonInterceptorHelperRestJson.ObjectToClearJsonString(
  AObject: TObject; AOptions: TJsonOptions; AValidations: TJsonValidationRules): string;
begin
  Result := Self.ObjectToJsonString(AObject, AOptions);

  Result := THorseJsonInterceptor.RemoverListHelperArray(Result);
end;

end.
