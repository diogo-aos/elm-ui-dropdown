
module Main exposing (main)

import Browser
import Html

import Element as E
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events

type alias Model =
    { favoriteFood : Maybe Food
    , status : Status}

type Status
    = Normal
    | SelectFood

initialModel : Model
initialModel =
    { favoriteFood = Nothing
    , status = Normal
    }
    
type FoodType
    = FastFood
    | Regional
        
type alias Food =
    { id : Int
    , name : String
    , foodType : FoodType
    }


foodList : List Food
foodList =
    [ Food 0 "Hotdog" FastFood
    , Food 1 "Hamburguer" FastFood
    , Food 2 "Taco" FastFood
    , Food 3 "Francesinha aka Little French" Regional
    , Food 4 "Sauerkraut" Regional
    , Food 5 "Kimchi" Regional
    ]

type Msg
    = NoAction
    | ClickedSelectFood
    | ClickedDropdownFood Food
      

update : Msg -> Model -> Model
update msg model =
    case msg of
        NoAction ->
            model
            
        ClickedSelectFood ->
            { model | status = SelectFood }
            
        ClickedDropdownFood food ->
            { model | status = Normal, favoriteFood = Just food }

view : Model -> Html.Html Msg
view model =
    let
        selectedFoodName = 
            case model.favoriteFood of
                Nothing -> "No food selected. Click here to select."
                Just food -> food.name
        dropdown =
            case model.status of
                Normal ->
                    E.el
                        [ Border.width 1
                        , Border.dashed
                        , E.padding 3
                        , Events.onClick ClickedSelectFood
                        ]
                        (E.text selectedFoodName)
                SelectFood ->
                    E.el
                        [ Border.width 1
                        , Border.dashed
                        , E.padding 3
                        , E.below (viewFoodList foodList)
                        ]
                        (E.text selectedFoodName)
                
    in
    E.layout
        []
        (
        E.column
            [ E.centerX
            , E.centerY
        ]
            [ E.text "You favorite food is:"
            , dropdown
            , E.text "... the best food."
            ]
        )

viewFoodList : List Food -> E.Element Msg
viewFoodList foods =
    E.column
        [ ]
        <|
            List.map viewFood foods

overColor : E.Color
overColor = E.rgb 0.9 0.9 0.1

white : E.Color
white = E.rgb 1 1 1

viewFood : Food -> E.Element Msg
viewFood food =
    E.el
        [ E.width E.fill
        , E.mouseOver [Background.color overColor]
        , Background.color white
        , Events.onClick (ClickedDropdownFood food)
        ]
        (E.text food.name)        
        
main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
