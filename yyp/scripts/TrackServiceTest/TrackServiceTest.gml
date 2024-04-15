function TrackServiceTest(): Test() constructor {

    ///@override
    ///@type {String}
    name = "Test TrackService.gml"

    ///@override
    ///@type {Struct[]}
    cases = [
        {
            name: "Track.update",
            config: {
            },
            test: function(config) {
                return {
                    message: "passed",
                    config: config
                }
            }
        }
    ]
}