package react.ubo;

import react.ReactMacro.jsx;
import react.ReactComponent.ReactComponentOfPropsAndState;
import mui.Color;
import mui.core.*;
import mui.core.styles.Styles;
import mui.core.styles.Classes;
import mui.core.form.FormControlMargin;
import mui.core.grid.GridSpacing;
import mui.core.button.ButtonVariant;
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
import react.ubo.vo.UBOVO;

typedef UBOFormProps = {
    ?ubo: UBOVO,
    canEdit: Bool,
    onSubmit: () -> Void,
    onSubmitSuccess: () -> Void,
    onSubmitFailure: () -> Void,
};

typedef UBOFormClasses = Classes<[datePickerInput]>;

typedef UBOFormPropsWithClasses = {
    >UBOFormProps,
    classes:UBOFormClasses,
};

typedef UBOFormState = {
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

@:publicProps(UBOFormProps)
@:wrap(Styles.withStyles(styles))
class UBOForm extends ReactComponentOfPropsAndState<UBOFormPropsWithClasses, UBOFormState> {

    public function new(props: UBOFormPropsWithClasses) {
        super(props);

        state = {
            isLoading: false,
            countrys: [],
        };
    }

    public static function styles(theme:Theme):ClassesDef<UBOFormClasses> {
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
            return jsx('<Box display="flex" py={4} justifyContent="center"><CircularProgress /></Box>');
        }

        var ubo = props.ubo;
        var initialValues = {
            FirstName: ubo == null ? "" : ubo.FirstName,
            LastName: ubo == null ? "" : ubo.LastName,
            Address: {
                AddressLine1: ubo == null ? "" : ubo.Address.AddressLine1,
                AddressLine2: ubo == null ? "" : (ubo.Address.AddressLine2 != null ? ubo.Address.AddressLine2 : ""),
                City: ubo == null ? "" : ubo.Address.City,
                Region: ubo == null ? "" : (ubo.Address.Region != null ? ubo.Address.Region : ""),
                PostalCode: ubo == null ? "" : ubo.Address.PostalCode,
                Country: ubo == null ? "FR" : ubo.Address.Country,
            },
            Nationality: ubo == null ? "FR" : ubo.Nationality,
            Birthday: ubo == null ? Date.now() : Date.fromTime(ubo.Birthday * 1000),
            Birthplace: {
                City: ubo == null ? "" : ubo.Birthplace.City,
                Country: ubo == null ? "FR" : ubo.Birthplace.Country,
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
                                        disabled={!props.canEdit}
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
                            
                            {renderButton(formikProps.isSubmitting)}
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
                disabled={!props.canEdit}
            />
        ;
    }

    private function renderCountryField(name: String, label: String, labelField: String) {
        var id = "ubo-country-" + name;

        return
            <FormControl fullWidth margin=${FormControlMargin.Dense}>
                <InputLabel id=$id>{label}</InputLabel>
                <Select labelId=$id name=$name fullWidth required disabled={!props.canEdit}>
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

    private function renderButton(isSubmitting: Bool) {
        if (!props.canEdit) return <></>;
        return 
            <Box pt={4} display="flex" justifyContent="center">
                <Button
                    disabled={isSubmitting}
                    variant={ButtonVariant.Contained}
                    color={Color.Primary}
                    type={mui.core.button.ButtonType.Submit}
                    >
                    Valider
                </Button>
            </Box>
        ;
    }
    
     /**
     * 
     */
     private function onSubmit(values: FormProps, formikBag: Dynamic) {
         props.onSubmit();
     }
}