// ************************************************************************
// ***************************** CEF4Delphi *******************************
// ************************************************************************
//
// CEF4Delphi is based on DCEF3 which uses CEF3 to embed a chromium-based
// browser in Delphi applications.
//
// The original license of DCEF3 still applies to CEF4Delphi.
//
// For more information about CEF4Delphi visit :
//         https://www.briskbard.com/index.php?lang=en&pageid=cef
//
//        Copyright � 2017 Salvador D�az Fau. All rights reserved.
//
// ************************************************************************
// ************ vvvv Original license and comments below vvvv *************
// ************************************************************************
(*
 *                       Delphi Chromium Embedded 3
 *
 * Usage allowed under the restrictions of the Lesser GNU General Public License
 * or alternatively the restrictions of the Mozilla Public License 1.1
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
 * the specific language governing rights and limitations under the License.
 *
 * Unit owner : Henri Gourvest <hgourvest@gmail.com>
 * Web site   : http://www.progdigy.com
 * Repository : http://code.google.com/p/delphichromiumembedded/
 * Group      : http://groups.google.com/group/delphichromiumembedded
 *
 * Embarcadero Technologies, Inc is not permitted to use or redistribute
 * this source code without explicit permission.
 *
 *)

unit uCEFRenderHandler;

{$IFNDEF CPUX64}
  {$ALIGN ON}
  {$MINENUMSIZE 4}
{$ENDIF}

{$I cef.inc}

interface

uses
  uCEFBaseRefCounted, uCEFInterfaces, uCEFTypes;

type
  TCefRenderHandlerOwn = class(TCefBaseRefCountedOwn, ICefRenderHandler)
    protected
      function  GetRootScreenRect(const browser: ICefBrowser; rect: PCefRect): Boolean; virtual;
      function  GetViewRect(const browser: ICefBrowser; rect: PCefRect): Boolean; virtual;
      function  GetScreenPoint(const browser: ICefBrowser; viewX, viewY: Integer; screenX, screenY: PInteger): Boolean; virtual;
      function  GetScreenInfo(const browser: ICefBrowser; screenInfo: PCefScreenInfo): Boolean; virtual;
      procedure OnPopupShow(const browser: ICefBrowser; show: Boolean); virtual;
      procedure OnPopupSize(const browser: ICefBrowser; const rect: PCefRect); virtual;
      procedure OnPaint(const browser: ICefBrowser; kind: TCefPaintElementType; dirtyRectsCount: NativeUInt; const dirtyRects: PCefRectArray; const buffer: Pointer; width, height: Integer); virtual;
      procedure OnCursorChange(const browser: ICefBrowser; cursor: TCefCursorHandle; CursorType: TCefCursorType; const customCursorInfo: PCefCursorInfo); virtual;
      function  OnStartDragging(const browser: ICefBrowser; const dragData: ICefDragData; allowedOps: TCefDragOperations; x, y: Integer): Boolean; virtual;
      procedure OnUpdateDragCursor(const browser: ICefBrowser; operation: TCefDragOperation); virtual;
      procedure OnScrollOffsetChanged(const browser: ICefBrowser; x, y: Double); virtual;
      procedure OnIMECompositionRangeChanged(const browser: ICefBrowser; const selected_range: PCefRange; character_boundsCount: NativeUInt; const character_bounds: PCefRect); virtual;

    public
      constructor Create; virtual;
  end;

  TCustomRenderHandler = class(TCefRenderHandlerOwn)
    protected
      FEvent: IChromiumEvents;

      function  GetRootScreenRect(const browser: ICefBrowser; rect: PCefRect): Boolean; override;
      function  GetViewRect(const browser: ICefBrowser; rect: PCefRect): Boolean; override;
      function  GetScreenPoint(const browser: ICefBrowser; viewX, viewY: Integer; screenX, screenY: PInteger): Boolean; override;
      procedure OnPopupShow(const browser: ICefBrowser; show: Boolean); override;
      procedure OnPopupSize(const browser: ICefBrowser; const rect: PCefRect); override;
      procedure OnPaint(const browser: ICefBrowser; kind: TCefPaintElementType; dirtyRectsCount: NativeUInt; const dirtyRects: PCefRectArray; const buffer: Pointer; width, height: Integer); override;
      procedure OnCursorChange(const browser: ICefBrowser; cursor: TCefCursorHandle; cursorType: TCefCursorType; const customCursorInfo: PCefCursorInfo); override;
      function  GetScreenInfo(const browser: ICefBrowser; screenInfo: PCefScreenInfo): Boolean; override;
      function  OnStartDragging(const browser: ICefBrowser; const dragData: ICefDragData; allowedOps: TCefDragOperations; x, y: Integer): Boolean; override;
      procedure OnUpdateDragCursor(const browser: ICefBrowser; operation: TCefDragOperation); override;
      procedure OnScrollOffsetChanged(const browser: ICefBrowser; x, y: Double); override;
      procedure OnIMECompositionRangeChanged(const browser: ICefBrowser; const selected_range: PCefRange; character_boundsCount: NativeUInt; const character_bounds: PCefRect); override;

    public
      constructor Create(const events: IChromiumEvents); reintroduce; virtual;
  end;

implementation

uses
  uCEFMiscFunctions, uCEFLibFunctions, uCEFBrowser, uCEFDragData;


function cef_render_handler_get_root_screen_rect(self: PCefRenderHandler;
  browser: PCefBrowser; rect: PCefRect): Integer; stdcall;
begin
  with TCefRenderHandlerOwn(CefGetObject(self)) do
    Result := Ord(GetRootScreenRect(TCefBrowserRef.UnWrap(browser), rect));
end;

function cef_render_handler_get_view_rect(self: PCefRenderHandler;
  browser: PCefBrowser; rect: PCefRect): Integer; stdcall;
begin
  with TCefRenderHandlerOwn(CefGetObject(self)) do
    Result := Ord(GetViewRect(TCefBrowserRef.UnWrap(browser), rect));
end;

function cef_render_handler_get_screen_point(self: PCefRenderHandler;
  browser: PCefBrowser; viewX, viewY: Integer; screenX, screenY: PInteger): Integer; stdcall;
begin
  with TCefRenderHandlerOwn(CefGetObject(self)) do
    Result := Ord(GetScreenPoint(TCefBrowserRef.UnWrap(browser), viewX, viewY, screenX, screenY));
end;

function cef_render_handler_get_screen_info(self: PCefRenderHandler;
  browser: PCefBrowser; screen_info: PCefScreenInfo): Integer; stdcall;
begin
  with TCefRenderHandlerOwn(CefGetObject(self)) do
    Result := Ord(GetScreenInfo(TCefBrowserRef.UnWrap(browser), screen_info));
end;

procedure cef_render_handler_on_popup_show(self: PCefRenderProcessHandler;
  browser: PCefBrowser; show: Integer); stdcall;
begin
  with TCefRenderHandlerOwn(CefGetObject(self)) do
    OnPopupShow(TCefBrowserRef.UnWrap(browser), show <> 0);
end;

procedure cef_render_handler_on_popup_size(self: PCefRenderProcessHandler;
  browser: PCefBrowser; const rect: PCefRect); stdcall;
begin
  with TCefRenderHandlerOwn(CefGetObject(self)) do
    OnPopupSize(TCefBrowserRef.UnWrap(browser), rect);
end;

procedure cef_render_handler_on_paint(self: PCefRenderProcessHandler;
  browser: PCefBrowser; kind: TCefPaintElementType; dirtyRectsCount: NativeUInt;
  const dirtyRects: PCefRectArray; const buffer: Pointer; width, height: Integer); stdcall;
begin
  with TCefRenderHandlerOwn(CefGetObject(self)) do
    OnPaint(TCefBrowserRef.UnWrap(browser), kind, dirtyRectsCount, dirtyRects,
      buffer, width, height);
end;

procedure cef_render_handler_on_cursor_change(self: PCefRenderProcessHandler;
  browser: PCefBrowser; cursor: TCefCursorHandle; type_: TCefCursorType;
  const custom_cursor_info: PCefCursorInfo); stdcall;
begin
  with TCefRenderHandlerOwn(CefGetObject(self)) do
    OnCursorChange(TCefBrowserRef.UnWrap(browser), cursor, type_, custom_cursor_info);
end;

function cef_render_handler_start_dragging(self: PCefRenderProcessHandler; browser: PCefBrowser;
  drag_data: PCefDragData; allowed_ops: TCefDragOperations; x, y: Integer): Integer; stdcall;
begin
  with TCefRenderHandlerOwn(CefGetObject(self)) do
    Result := Ord(OnStartDragging(TCefBrowserRef.UnWrap(browser),
      TCefDragDataRef.UnWrap(drag_data), allowed_ops, x, y));
end;

procedure cef_render_handler_update_drag_cursor(self: PCefRenderProcessHandler;
  browser: PCefBrowser; operation: TCefDragOperation); stdcall;
begin
  with TCefRenderHandlerOwn(CefGetObject(self)) do
    OnUpdateDragCursor(TCefBrowserRef.UnWrap(browser), operation);
end;

procedure cef_render_handler_on_scroll_offset_changed(self: PCefRenderProcessHandler;
  browser: PCefBrowser; x, y: Double); stdcall;
begin
  with TCefRenderHandlerOwn(CefGetObject(self)) do
    OnScrollOffsetChanged(TCefBrowserRef.UnWrap(browser), x, y);
end;

procedure cef_render_handler_on_ime_composition_range_changed(self: PCefRenderProcessHandler;
                                                                    browser: PCefBrowser;
                                                              const selected_range: PCefRange;
                                                                    character_boundsCount: NativeUInt;
                                                              const character_bounds: PCefRect); stdcall;
begin
  with TCefRenderHandlerOwn(CefGetObject(self)) do
    OnIMECompositionRangeChanged(TCefBrowserRef.UnWrap(browser), selected_range, character_boundsCount, character_bounds);
end;

constructor TCefRenderHandlerOwn.Create;
begin
  CreateData(SizeOf(TCefRenderHandler), False);

  with PCefRenderHandler(FData)^ do
    begin
      get_root_screen_rect             := cef_render_handler_get_root_screen_rect;
      get_view_rect                    := cef_render_handler_get_view_rect;
      get_screen_point                 := cef_render_handler_get_screen_point;
      on_popup_show                    := cef_render_handler_on_popup_show;
      on_popup_size                    := cef_render_handler_on_popup_size;
      on_paint                         := cef_render_handler_on_paint;
      on_cursor_change                 := cef_render_handler_on_cursor_change;
      start_dragging                   := cef_render_handler_start_dragging;
      update_drag_cursor               := cef_render_handler_update_drag_cursor;
      on_scroll_offset_changed         := cef_render_handler_on_scroll_offset_changed;
      on_ime_composition_range_changed := cef_render_handler_on_ime_composition_range_changed;
    end;
end;

function TCefRenderHandlerOwn.GetRootScreenRect(const browser: ICefBrowser;
  rect: PCefRect): Boolean;
begin
  Result := False;
end;

function TCefRenderHandlerOwn.GetScreenInfo(const browser: ICefBrowser;
  screenInfo: PCefScreenInfo): Boolean;
begin
  Result := False;
end;

function TCefRenderHandlerOwn.GetScreenPoint(const browser: ICefBrowser; viewX,
  viewY: Integer; screenX, screenY: PInteger): Boolean;
begin
  Result := False;
end;

function TCefRenderHandlerOwn.GetViewRect(const browser: ICefBrowser;
  rect: PCefRect): Boolean;
begin
  Result := False;
end;

procedure TCefRenderHandlerOwn.OnCursorChange(const browser: ICefBrowser;
  cursor: TCefCursorHandle; CursorType: TCefCursorType;
  const customCursorInfo: PCefCursorInfo);
begin

end;

procedure TCefRenderHandlerOwn.OnPaint(const browser: ICefBrowser;
  kind: TCefPaintElementType; dirtyRectsCount: NativeUInt;
  const dirtyRects: PCefRectArray; const buffer: Pointer; width, height: Integer);
begin

end;

procedure TCefRenderHandlerOwn.OnPopupShow(const browser: ICefBrowser;
  show: Boolean);
begin

end;

procedure TCefRenderHandlerOwn.OnPopupSize(const browser: ICefBrowser;
  const rect: PCefRect);
begin

end;

procedure TCefRenderHandlerOwn.OnScrollOffsetChanged(
  const browser: ICefBrowser; x, y: Double);
begin

end;

procedure TCefRenderHandlerOwn.OnIMECompositionRangeChanged(const browser               : ICefBrowser;
                                                            const selected_range        : PCefRange;
                                                                  character_boundsCount : NativeUInt;
                                                            const character_bounds      : PCefRect);
begin

end;

function TCefRenderHandlerOwn.OnStartDragging(const browser: ICefBrowser;
  const dragData: ICefDragData; allowedOps: TCefDragOperations; x,
  y: Integer): Boolean;
begin
  Result := False;
end;

procedure TCefRenderHandlerOwn.OnUpdateDragCursor(const browser: ICefBrowser;
  operation: TCefDragOperation);
begin

end;

// TCustomRenderHandler

constructor TCustomRenderHandler.Create(const events: IChromiumEvents);
begin
  inherited Create;
  FEvent := events;
end;

function TCustomRenderHandler.GetRootScreenRect(const browser: ICefBrowser;
  rect: PCefRect): Boolean;
begin
  Result := FEvent.doOnGetRootScreenRect(browser, rect);
end;

function TCustomRenderHandler.GetScreenInfo(const browser: ICefBrowser;
  screenInfo: PCefScreenInfo): Boolean;
begin
  Result := FEvent.doOnGetScreenInfo(browser, screenInfo);
end;

function TCustomRenderHandler.GetScreenPoint(const browser: ICefBrowser; viewX,
  viewY: Integer; screenX, screenY: PInteger): Boolean;
begin
  Result := FEvent.doOnGetScreenPoint(browser, viewX, viewY, screenX, screenY);
end;

function TCustomRenderHandler.GetViewRect(const browser: ICefBrowser;
  rect: PCefRect): Boolean;
begin
  Result := FEvent.doOnGetViewRect(browser, rect);
end;

procedure TCustomRenderHandler.OnCursorChange(const browser: ICefBrowser;
  cursor: TCefCursorHandle; cursorType: TCefCursorType;
  const customCursorInfo: PCefCursorInfo);
begin
  FEvent.doOnCursorChange(browser, cursor, cursorType, customCursorInfo);
end;

procedure TCustomRenderHandler.OnPaint(const browser: ICefBrowser;
  kind: TCefPaintElementType; dirtyRectsCount: NativeUInt;
  const dirtyRects: PCefRectArray; const buffer: Pointer; width, height: Integer);
begin
  FEvent.doOnPaint(browser, kind, dirtyRectsCount, dirtyRects, buffer, width, height);
end;

procedure TCustomRenderHandler.OnPopupShow(const browser: ICefBrowser;
  show: Boolean);
begin
  FEvent.doOnPopupShow(browser, show);
end;

procedure TCustomRenderHandler.OnPopupSize(const browser: ICefBrowser;
  const rect: PCefRect);
begin
  FEvent.doOnPopupSize(browser, rect);
end;

procedure TCustomRenderHandler.OnScrollOffsetChanged(
  const browser: ICefBrowser; x, y: Double);
begin
  FEvent.doOnScrollOffsetChanged(browser, x, y);
end;

procedure TCustomRenderHandler.OnIMECompositionRangeChanged(const browser: ICefBrowser;
                                                            const selected_range: PCefRange;
                                                                  character_boundsCount: NativeUInt;
                                                            const character_bounds: PCefRect);
begin
  FEvent.doOnIMECompositionRangeChanged(browser, selected_range, character_boundsCount, character_bounds);
end;

function TCustomRenderHandler.OnStartDragging(const browser: ICefBrowser;
  const dragData: ICefDragData; allowedOps: TCefDragOperations; x,
  y: Integer): Boolean;
begin
  Result := FEvent.doOnStartDragging(browser, dragData, allowedOps, x, y);
end;

procedure TCustomRenderHandler.OnUpdateDragCursor(const browser: ICefBrowser;
  operation: TCefDragOperation);
begin
  FEvent.doOnUpdateDragCursor(browser, operation);
end;

end.
