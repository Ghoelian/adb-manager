#ifndef FLUTTER_MY_APPLICATION_H_
#define FLUTTER_MY_APPLICATION_H_

#include <gtk/gtk.h>

G_DECLARE_FINAL_TYPE(AdbManager, adb_manager, MY, APPLICATION,
                     GtkApplication)

/**
 * adb_manager_new:
 *
 * Creates a new Flutter-based application.
 *
 * Returns: a new #AdbManager.
 */
AdbManager* adb_manager_new();

#endif  // FLUTTER_MY_APPLICATION_H_
