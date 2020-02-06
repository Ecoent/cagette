package react.ubo;

import react.ReactMacro.jsx;
import react.ReactComponent.ReactComponentOfPropsAndState;
import mui.core.*;
import mui.core.styles.Styles;
import mui.core.styles.Classes;
import mui.core.form.FormControlMargin;
import mui.core.grid.GridSpacing;
import react.mui.pickers.MuiPickersUtilsProvider;
import dateFns.DateFnsLocale;
import dateFns.FrDateFnsUtils;
import react.mui.CagetteTheme;
import react.mui.Box;
import react.formik.Formik;
import react.formik.Form;
import react.formikMUI.TextField;
import react.formikMUI.DatePicker;
import react.formikMUI.Select;

typedef UBOPeopleFormProps = {};

typedef UBOPeopleFormClasses = Classes<[datePickerInput]>;

typedef UBOPeopleFormPropsWithClasses = {
    >UBOPeopleFormProps,
    classes:UBOPeopleFormClasses,
};

typedef UBOPeopleFormState = {
    isLoading: Bool,
    countrys: Array<{alpha2: String, nationality: String, country: String}>
};

typedef FormProps = {
    FirstName: String,
    LastName: String,
    Address: {
        AddressLine1: String,
        ?AddressLine2: String,
        City: String,
        PostalCode: String,
        Country: String,
        ?Region: String,
    },
    Nationality: String,
    Birthday: Date,
    Birthplace: {
        City: String,
        Country: String
    }
};

@:publicProps(UBOPeopleFormProps)
@:wrap(Styles.withStyles(styles))
class UBOPeopleForm extends ReactComponentOfPropsAndState<UBOPeopleFormPropsWithClasses, UBOPeopleFormState> {

    public function new(props: UBOPeopleFormPropsWithClasses) {
        super(props);

        state = {
            isLoading: false,
            countrys: [],
        };
    }

    public static function styles(theme:Theme):ClassesDef<UBOPeopleFormClasses> {
        return {
            datePickerInput: {
                textTransform: css.TextTransform.Capitalize
              }
        }
    }

    override function componentDidMount() {
        setState({ isLoading: true });

        js.Browser.window.fetch("/data/iso-3166-french.json")
            .then(res -> {
                if (!res.ok) {
                    throw res.statusText;
                }
                return res.json();
            }).then(res -> {
                setState({ isLoading: false, countrys: cast res });
                return true;
            }).catchError(err -> {
                trace(err);
            });
    }

    override public function render() {
        if (state.isLoading || state.countrys.length == 0) {
            return jsx('<CircularProgress />');
        }

        var initialValues = {
            FirstName: "",
            LastName: "",
            Address: {
                AddressLine1: "",
                AddressLine2: "",
                City: "",
                Region: "",
                PostalCode: "",
                Country: "FR"
            },
            Nationality: "FR",
            Birthday: Date.now(),
            Birthplace: {
                City: "",
                Country: "FR",
            }
        };

        var res = 
            <MuiPickersUtilsProvider utils={FrDateFnsUtils} locale=${DateFnsLocale.fr} >
                <Formik initialValues=$initialValues onSubmit=$onSubmit>
                    {formikProps -> (
                        <Form>
                            {renderTwoColumns(
                                renderTextField("FirstName", "Prénom"),
                                renderTextField("LastName", "Nom")
                            )}
                           
                            {renderTextField("Address.AddressLine1", "Adresse")}
                            {renderTextField("Address.AddressLine2", "Adresse 2", false)}

                            {renderTwoColumns(
                                renderTextField("Address.City", "Ville"),
                                renderTextField("Address.PostalCode", "Code postal")
                            )}
                            
                            {renderTwoColumns(
                                renderCountryField("Address.Country", "Pays", "country"),
                                renderRegionField(formikProps)
                            )}
                            
                            {renderTwoColumns(
                                renderCountryField("Nationality", "Nationalité", "nationality"),
                                <FormControl fullWidth margin={FormControlMargin.Dense}>
                                    <DatePicker
                                        InputProps={{
                                            classes: {
                                                input: ${props.classes.datePickerInput}
                                            }
                                        }}
                                        required 
                                        cancelLabel="Annuler"
                                        format="d MMMM yyyy"
                                        name="Birthday"
                                        label="Date de naissance"
                                    />
                                </FormControl>
                            )}

                            {renderTwoColumns(
                                renderTextField("Birthplace.City", "Ville de naissance"),
                                renderCountryField("Birthplace.Country", "Pays de naissance", "country")
                            )}
                            
                        </Form>
                    )}
                </Formik>
            </MuiPickersUtilsProvider>
        ;

        return jsx('$res');
    }



    /**
     * 
     */
    private function renderTwoColumns(childLeft: Dynamic, ?childRight: Dynamic) {
        var colSize = 12;
        var right = <></>;
        if (childRight != null) {
            colSize = 6;
            right = <Grid item xs={colSize}>{childRight}</Grid>;
        }
        return  
            <Grid container spacing=${GridSpacing.Spacing_4}>
                <Grid item xs={colSize}>
                    {childLeft}
                </Grid>
                {right}
            </Grid>
        ;
     }
    
    private function renderTextField(name: String, label: String, required: Bool = true, fullWidth: Bool =true) {
        return  
            <TextField
                margin={mui.core.form.FormControlMarginNoneDense.Dense}
                fullWidth=$fullWidth
                required=$required
                name=$name
                label=$label
            />
        ;
    }

    private function renderCountryField(name: String, label: String, labelField: String) {
        var id = "ubo-country-" + name;

        return
            <FormControl fullWidth margin=${FormControlMargin.Dense}>
                <InputLabel id=$id>{label}</InputLabel>
                <Select labelId=$id name=$name fullWidth required>
                    ${state.countrys.map(c -> 
                        <MenuItem key=${c.alpha2} value=${c.alpha2} dense>
                            ${untyped c[labelField]}
                        </MenuItem>
                    )}
                </Select>
            </FormControl>
        ;
    }
    
    private function renderRegionField(formikProps: Dynamic) {
        var countryCode = formikProps.values.Address.Country;
        if (["US", "CA", "MX"].indexOf(countryCode) != -1) {
            return renderTextField("Address.Region", "Région");
        }
        return <></>;
    }
    
     /**
     * 
     */
     private function onSubmit(values: FormProps, formikBag: Dynamic) {}
}