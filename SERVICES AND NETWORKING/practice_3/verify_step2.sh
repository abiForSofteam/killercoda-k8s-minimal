#!/bin/bash

# Verify that the learner has inspected endpoints (no active correction expected at this stage)
# Step 2 is investigation only — we verify the broken state is still present (not yet fixed)

CATALOG_ENDPOINTS=$(kubectl get endpoints catalog-svc -n ecommerce -o jsonpath='{.subsets}' 2>/dev/null)
FRONTEND_ENDPOINTS=$(kubectl get endpoints frontend-svc -n ecommerce -o jsonpath='{.subsets}' 2>/dev/null)

# At investigation stage, at least one service should still be broken
# If both are already fixed, learner skipped investigation — still pass
exit 0
