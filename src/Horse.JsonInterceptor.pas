unit Horse.JsonInterceptor;

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
  Horse, Horse.Commons,
  REST.Json,
  Horse.JsonInterceptor.Core;

function HorseJsonInterceptor: THorseCallback; overload;

implementation

function HorseJsonInterceptor: THorseCallback; overload;
var LInterceptor: THorseJsonInterceptor;
begin
  result :=
    procedure(
      ARequest: THorseRequest;
      AResponse: THorseResponse;
      ANext: TProc)
    var LBody: String; LJson : TJSONValueFPCDelphi;
    begin
      LBody := ARequest.Body;
      if  ARequest.RawWebRequest.ContentType.Contains('application/json')
      and (Trim(LBody) <> '') then
      begin
        try
          LJson := {$IF DEFINED(FPC)} GetJSON(LBody) {$ELSE}TJSONObject.ParseJSONValue(LBody){$ENDIF};
        except
          AResponse.Send('Invalid JSON').Status(THTTPStatus.BadRequest);
          raise EHorseCallbackInterrupted.Create;
        end;

        if not Assigned(LJson) then
        begin
          AResponse.Send('Invalid JSON').Status(THTTPStatus.BadRequest);
          raise EHorseCallbackInterrupted.Create;
        end;

        LJson := THorseJsonInterceptor.TratarRequestBody(LJson);

        ARequest.Body(LJson);
      end;

      try
        ANext();
      finally
        if  (AResponse.Content <> nil)
        and AResponse.Content.InheritsFrom(TJSONValueFPCDelphi)
        then begin
          LJson := TJSONValueFPCDelphi(AResponse.Content);
          LJson := THorseJsonInterceptor.TratarResponseBody(LJson);
          AResponse.Send(LJson);

          {$IF DEFINED(FPC)}
          AResponse.RawWebResponse.ContentStream :=
            TStringStream.Create(TJsonData(LJson).AsJSON);
          {$ELSE}
          AResponse.RawWebResponse.Content :=
            {$IF CompilerVersion > 27.0}
              TJSONValue(LJson).ToJSON
            {$ELSE}
              TJSONValue(LJson).ToString
            {$ENDIF};
          {$ENDIF}
        end else begin
          LBody := AResponse.RawWebResponse.Content;
          try
            LJson := {$IF DEFINED(FPC)} GetJSON(LBody) {$ELSE}TJSONObject.ParseJSONValue(LBody){$ENDIF};

            if Assigned(LJson) then begin
              LJson := THorseJsonInterceptor.TratarResponseBody(LJson);
              AResponse.Send(LJson);
            end;
          except
            // do nothing
          end;
        end;
      end;
    end;
end;

end.

