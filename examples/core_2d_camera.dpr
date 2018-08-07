program core_2d_camera;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  common,
  raylib in '..\libs\raylib.pas';

const
  MAX_BUILDINGS = 100;

var
  player: TRectangle;
  buildings: array[0..MAX_BUILDINGS - 1] of TRectangle;
  buildColors: array[0..MAX_BUILDINGS - 1] of TColor;
  spacing: Single = 0;
  v: TVector2;
  camera: TCamera2D;
  i: Integer;
begin
  InitWindow(screenWidth, screenHeight, 'raylib [core] example - 2d camera');

  player.&Set(400, 280, 40, 40);

  for i := 0 to MAX_BUILDINGS-1 do
  begin
    buildings[i].width := GetRandomValue(50, 200);
    buildings[i].height := GetRandomValue(100, 800);
    buildings[i].y := screenHeight - 130 - buildings[i].height;
    buildings[i].x := -6000 + spacing;
    spacing := spacing + buildings[i].width;
    buildColors[i].&Set(GetRandomValue(200, 240), GetRandomValue(200, 240), GetRandomValue(200, 250), 255);
  end;

  camera.target.&Set(player.x + 20, player.y + 20);
  camera.offset.&Set(0, 0);
  camera.rotation := 0.0;
  camera.zoom := 1.0;

  SetTargetFPS(60);

  while not WindowShouldClose do
  begin
    if IsKeyDown(KEY_RIGHT) then
      begin
        player.x := player.x + 2;
        camera.offset.x := camera.offset.x - 2;
      end
    else if IsKeyDown(KEY_LEFT) then
      begin
        player.x := player.x - 2;
        camera.offset.x := camera.offset.x + 2;
      end;

    camera.target.&Set(player.x + 20, player.y + 20);

    if IsKeyDown(KEY_A) then
      camera.rotation := camera.rotation - 1
    else if IsKeyDown(KEY_S) then
      camera.rotation := camera.rotation + 1;

    if camera.rotation > 40 then
      camera.rotation := 40
    else if camera.rotation < -40 then
      camera.rotation := -40;

    camera.zoom := camera.zoom + Single(GetMouseWheelMove) * 0.05;

    if camera.zoom > 3.0 then camera.zoom := 3.0
    else if camera.zoom < 0.1 then camera.zoom := 0.1;

    if IsKeyPressed(KEY_R) then
    begin
      camera.zoom := 1.0;
      camera.rotation := 0.0;
    end;

    BeginDrawing();
      ClearBackground(RAYWHITE);
      BeginMode2D(camera);
        DrawRectangle(-6000, 320, 13000, 8000, DARKGRAY);
        for i := 0 to MAX_BUILDINGS-1 do DrawRectangleRec(buildings[i], buildColors[i]);
        DrawRectangleRec(player, RED);
        DrawRectangle(Round(camera.target.x), -500, 1, screenHeight*4, GREEN);
        DrawRectangle(-500, Round(camera.target.y), screenWidth*4, 1, GREEN);
      EndMode2D;

      DrawText('SCREEN AREA', 640, 10, 20, RED);

      DrawRectangle(0, 0, screenWidth, 5, RED);
      DrawRectangle(0, 5, 5, screenHeight - 10, RED);
      DrawRectangle(screenWidth - 5, 5, 5, screenHeight - 10, RED);
      DrawRectangle(0, screenHeight - 5, screenWidth, 5, RED);

      DrawRectangle( 10, 10, 250, 113, Fade(SKYBLUE, 0.5));
      DrawRectangleLines( 10, 10, 250, 113, BLUE);

      DrawText('Free 2d camera controls:', 20, 20, 10, BLACK);
      DrawText('- Right/Left to move Offset', 40, 40, 10, DARKGRAY);
      DrawText('- Mouse Wheel to Zoom in-out', 40, 60, 10, DARKGRAY);
      DrawText('- A / S to Rotate', 40, 80, 10, DARKGRAY);
      DrawText('- R to reset Zoom and Rotation', 40, 100, 10, DARKGRAY);
    EndDrawing;
  end;


  CloseWindow;

end.
