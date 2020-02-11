package react.ubo;

import react.ReactMacro.jsx;
import react.ReactComponent;
import mui.core.*;
import mui.core.typography.TypographyVariant;
import mui.icon.Close;
import react.mui.Box;
import react.ubo.UBOForm;
import react.ubo.vo.UBOVO;

typedef UBOFormDialogProps = {
    open: Bool,
    canEdit: Bool,
    ?ubo: UBOVO,
    onClose: (refresh: Bool) -> Void,
};

typedef UBOFormDialogState = {
    isSubmiting: Bool,
}

class UBOFormDialog extends ReactComponentOfPropsAndState<UBOFormDialogProps, UBOFormDialogState> {

    public function new(props: UBOFormDialogProps) {
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
                    <UBOForm
                        ubo={props.ubo}
                        canEdit={props.canEdit}
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
        return 
            <DialogTitle>
                <Box display="flex" justifyContent="space-between" alignItems="center">
                    <Box>
                        <Typography variant={TypographyVariant.H5}>Bénéficiaire effectif (UBO)</Typography>
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
        props.onClose(true);
    }

    private function onSubmitFailure() {
        setState({ isSubmiting: false });
    }
}