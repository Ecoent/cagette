package react.ubo;

import react.ReactMacro.jsx;
import react.ReactComponent;
import mui.core.*;
import mui.core.typography.TypographyVariant;
import mui.icon.Close;
import react.mui.Box;
import react.ubo.UBOPeopleForm;
import react.ubo.vo.UBOVO;

typedef UBOPeopleDialogFormProps = {
    open: Bool,
    ?people: UBOVO,
    onClose: (refresh: Bool) -> Void,
};

typedef UBOPeopleDialogFormState = {
    isSubmiting: Bool,
}

class UBOPeopleDialogForm extends ReactComponentOfPropsAndState<UBOPeopleDialogFormProps, UBOPeopleDialogFormState> {

    public function new(props: UBOPeopleDialogFormProps) {
        super(props);

        state = {
            isSubmiting: false,
        }
    }

    override public function render() {
        var res = 
            <Dialog open={props.open} onClose=$close>
                {renderDialogTitle()}
                <DialogContent>
                    <UBOPeopleForm
                        people={props.people}
                        onSubmit={onSubmit}
                        onSubmitSuccess={onSubmitSuccess}
                        onSubmitFailure={onSubmitFailure}
                        />
                </DialogContent>
                {renderSubmitingProgress()}
            </Dialog>
        ;

        return jsx('$res');
    }

    private function renderDialogTitle() {
        var title = "Création d'un UBO";

        if (props.people != null) {
            title = 'Edition de ${props.people.FirstName} ${props.people.LastName}';
        }

        return 
            <DialogTitle>
                <Box display="flex" justifyContent="space-between" alignItems="center">
                    <Box>
                        <Typography variant={TypographyVariant.H5}>Bénéficiaire effectif</Typography>
                        <Typography variant={TypographyVariant.H6}>{title}</Typography>
                    </Box>
                    <IconButton disabled={state.isSubmiting} onClick=$close>
                        <Close />
                    </IconButton>
                </Box>
            </DialogTitle>
        ;
    }

    private function renderSubmitingProgress() {
        if (state.isSubmiting) return <LinearProgress />;
        return <></>;
    }

    private function close() {
        if (!state.isSubmiting) {
            props.onClose(false);
        }
    }

    private function onSubmit() {
        setState({ isSubmiting: true });
    }

    private function onSubmitSuccess() {
        setState({ isSubmiting: false });
    }

    private function onSubmitFailure() {
        setState({ isSubmiting: false });
    }
}