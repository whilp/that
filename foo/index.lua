re = require 're'
sqlite3 = require 'lsqlite3'
reNumberPath = re.compile[[^/([0-9][0-9]*)$]]
function SetupSql()
   if not db then
      db = sqlite3.open('redbean.sqlite3')
      db:busy_timeout(1000)
      db:exec[[PRAGMA journal_mode=WAL]]
      db:exec[[PRAGMA synchronous=NORMAL]]
      getBarStmt = db:prepare[[
         SELECT
            foo
         FROM
            Bar
         WHERE
            id = ?
      ]]
   end
end
local function GetBar(id)
   if not getBarStmt then
      Log(kLogWarn, 'prepare failed: ' .. db:errmsg())
      return nil
   end
   getBarStmt:reset()
   getBarStmt:bind(1, id)
   for bar in getBarStmt:nrows() do
      return bar
   end
   return nil
end
function OnHttpRequest()
   SetupSql()
   _, id = reNumberPath:search(GetPath())
   if id then
      bar = GetBar(id)
      SetHeader('Content-Type', 'text/plain; charset=utf-8')
      Write(string(bar.foo))
      return
   end
   Route()
   SetHeader('Content-Language', 'en-US')
end