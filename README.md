
## Usage/Examples

You can add this to your `qb-radialmenu` line 295
```lua
{
            id = 'Car',
                title = 'Car',
                icon = 'car',
                items = {
                    {
                        id = 'Keys',
                        title = 'Give car Keys',
                        icon = 'key',
                        type = 'client',
                        event = 'ef-keys:client:givekeys',
                        shouldClose = true
                    },
                }
```



