--Type Definitions
--Modernised 10/23/2020 (i think)

--Any script that requires this will have these types defined

--made by prankster (of course)

--defines any regular table
export type GenericTable = {[any]: any};

export type Signal = {
    Name: string,
    Connections: {[any]: any},
    YieldingThreads: {[any]: any}
}

export type Connection = {
    Signal: Signal?,
    Delegate: any,
    Index: number,
}

export type User = {
    username: string,
    userid: number,
    Character: Instance,
    CharacterAdded: RBXScriptSignal,
}

export type Character = {
    Name : string,
    User: User?,
    RootPart: Instance,
    Humanoid: Instance,
    Position: Vector3,
    WalkSpeed: number,
}



return {};