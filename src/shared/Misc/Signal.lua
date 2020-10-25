--Custom RBXScriptSignal
--this involves proper Roblox OOP
--I would be using BindableEvents but they are not really friends with things that involve OOP, eh?

--inject types
require(script.Parent.TypeDefinitions);

local signalStatic = {};
signalStatic.__index = signalStatic;

local connectionStatic = {};
connectionStatic.__index = connectionStatic;

local ERR_NOT_INSTANCE = "Cannot statically invoke method %s - It is an instance method. Call it on an instance of this class with Signal.new()";

local ERR_HANDLER_EXCEPTION = "There was an error thrown in your %s handler event: %s";

function signalStatic.new(signalName: string): Signal
    local signalObj: Signal = {
        Name = signalName;
        Connections = {};
        YieldingThreads = {};
    }

    setmetatable(signalObj, signalStatic);
    return signalObj;
end

local function NewConnection(sig: Signal, Delegate: any): Connection
    local connectionObj: Connection = {
        Signal = sig;
        Delegate = Delegate;
        Index = -1;
    }

    return setmetatable(connectionObj, connectionStatic);
end

local function threadAndReportError(func: any, args: GenericTable, handlerName: string)
    local TestService = game:GetService("TestService");

    local thread = coroutine.create(function()
        func(unpack(args));
    end)

    local success, err = coroutine.resume(thread);

    if not success then
        -- for the love of GOD ROBLOX please add in the ability to state
        --what type of output statement we can have, all this testservice at the start
        --is annoying as all hell

        TestService:Error(string.format(ERR_HANDLER_EXCEPTION, handlerName, err));
        TestService:Checkpoint(debug.traceback());
    end
end

function signalStatic:Connect(func): Connection
    assert(getmetatable(self) == signalStatic, string.format(ERR_NOT_INSTANCE, ":Connect()", "Signal.new()"));
    local connection = NewConnection(self, func);
    connection.Index = #self.Connections + 1;

    table.insert(self.Connections, connection.Index, connection);
    return connection;
end

function signalStatic:Fire(...)
    assert(getmetatable(self) == signalStatic, string.format(ERR_NOT_INSTANCE, ":Fire()", "Signal.new()"));

    local args = table.pack(...);
    local allCons = self.Connections;

    for index = 1, #allCons do
        local connection = allCons[index];
        if connection.Delegate ~= nil then
            threadAndReportError(connection.Delegate, args, connection.Signal.Name);
        end
    end

    local YieldingThreads = self.YieldingThreads;
    for index = 1, #YieldingThreads do
        local thread = YieldingThreads[index];
        coroutine.resume(thread);
    end
end

function signalStatic:Wait()
    local args = {};
    local threads = coroutine.running();
    table.insert(self.YieldingThreads, #self.YieldingThreads + 1, threads);
    args = { coroutine.yield() };
    table.remove(self.YieldingThreads, #self.YieldingThreads);

    return(unpack(args));
end

function connectionStatic:Disconnect()
    assert(getmetatable(self) == connectionStatic, string.format(ERR_NOT_INSTANCE, ":Disconnect()", "Signal.new()"));

    self.Delegate = nil;
    self.Index = -1;
    self.Signal = nil;

    setmetatable(self, nil);
end

function signalStatic:Dispose()
    assert(getmetatable(self) == signalStatic, string.format(ERR_NOT_INSTANCE, ":Dispose()", "Signal.new()"));

    local allCons = self.Connections;
    local allThreads = self.YieldingThreads;

    for index = 1, #allCons do
        local connection = allCons[index];
        connection:Disconnect();
    end

    for index = 1, #allThreads do
        local thread = allThreads[index];
        coroutine.resume(thread);
    end
end

return signalStatic;