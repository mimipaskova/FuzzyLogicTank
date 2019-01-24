function parse(request)
    local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");
    if (method == nil)then
        _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP");
    end
    local _GET = {}
    if (vars ~= nil)then
        for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
            _GET[k] = v
        end
    end
    local json;
    if (method == "POST") then
        _, _, json = string.find(request, "\n({.*})$");
        json = json and sjson.decode(json);
    end
    return {
        method = method,
        path = path,
        params = _GET,
        body = json
    };
end

function readFile(name)
    file.open(name);
    local buf = file.read();
    file.close();
    return buf;
end

function startServer()
    local index = readFile("index.html");
    local app = readFile("app.js");
    local statusResponse = "HTTP/1.1 200 OK\n";
            
--    tmr.alarm(0, 500, 1, readDistance);

    function onReceive(client, r)
        if (r.method == "GET" and r.path == "/") then
            client:send(readFile("index.html"));
        elseif (r.method == "GET" and r.path == "/fuzzy") then
            client:send(readFile("fuzzy.html"));
        elseif (r.method == "GET" and r.path == "/fuzzy/app.js") then
            client:send(readFile("fapp.js"));
        elseif (r.method == "GET" and r.path == "/app.js") then
            client:send(readFile("app.js"));
        elseif (r.method == "GET" and r.path == "/app.css") then
            client:send(readFile("app.css"));
        elseif (r.method == "POST" and r.path == "/power" and r.body) then
            if (r.body.left ~= nil and r.body.manual) then
                AUTOSPEED.auto = false
                MOTORS.setPower(r.body.left, r.body.right);
            else
                AUTOSPEED.auto = true
            end
--            MOTORS.setPower(400, -400);
            client:send(statusResponse);
        else
            local buf = "Oooops";
            client:send(buf);
        end
    end

    function onSent(sck)
        sck:close()
    end

    srv=net.createServer(net.TCP, 1);
    srv:listen(80, function(conn)
        local buffer = ""
        conn:on("receive", function(sck, c)
            buffer = buffer .. c
            local r = parse(buffer)
            if (r.method == "GET" or r.body) then
                onReceive(sck, r);
            end
        end)
        conn:on("sent", onSent)
    end)
end

wifi.setmode(wifi.STATION);
station_cfg={}
station_cfg.ssid="tankmimi"
station_cfg.pwd="tankmimi"
wifi.sta.config(station_cfg)
startServer();
